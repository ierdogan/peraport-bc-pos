codeunit 50100 "POS Mgt."
{
    procedure OpenSession(TerminalCode: Code[10]; OpeningAmount: Decimal): Code[20]
    var
        POSSession: Record "POS Session";
        SessionNo: Code[20];
    begin
        POSSession.Init();
        SessionNo := Format(Today, 0, '<Year4><Month,2><Day,2>') + '-' + TerminalCode + '-' + Format(Time, 0, '<Hours24><Minutes,2>');
        POSSession."Session No." := SessionNo;
        POSSession."Terminal Code" := TerminalCode;
        POSSession.Status := POSSession.Status::Open;
        POSSession."Opening Date" := Today;
        POSSession."Opening Time" := Time;
        POSSession."Opening Amount" := OpeningAmount;
        POSSession."Cashier ID" := UserId();
        POSSession.Insert(true);
        exit(SessionNo);
    end;

    procedure CloseSession(SessionNo: Code[20])
    var
        POSSession: Record "POS Session";
    begin
        POSSession.Get(SessionNo);
        POSSession.Status := POSSession.Status::Closed;
        POSSession."Closing Date" := Today;
        POSSession."Closing Time" := Time;
        POSSession.Modify(true);
    end;

    procedure AddLine(SessionNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[10]; Qty: Decimal; UnitPrice: Decimal; DiscPct: Decimal; ItemDescription: Text[100])
    var
        POSLine: Record "POS Line";
        LastLineNo: Integer;
    begin
        POSLine.SetRange("Session No.", SessionNo);
        if POSLine.FindLast() then
            LastLineNo := POSLine."Line No."
        else
            LastLineNo := 0;

        POSLine.Init();
        POSLine."Session No." := SessionNo;
        POSLine."Line No." := LastLineNo + 10000;
        POSLine."Item No." := ItemNo;
        POSLine.Description := ItemDescription;
        POSLine."Variant Code" := VariantCode;
        POSLine.Quantity := Qty;
        POSLine."Unit Price" := UnitPrice;
        POSLine."Discount %" := DiscPct;
        POSLine."Discount Amount" := Round(Qty * UnitPrice * DiscPct / 100);
        POSLine."Net Amount" := Round(Qty * UnitPrice) - POSLine."Discount Amount";
        POSLine."VAT %" := 20; // TODO: Item VAT posting group'tan al
        POSLine."VAT Amount" := Round(POSLine."Net Amount" * POSLine."VAT %" / 100);
        POSLine."Total Amount" := POSLine."Net Amount" + POSLine."VAT Amount";
        POSLine.Insert(true);
    end;

    /// <summary>
    /// Barkod ile ürün arar. Önce Item Reference (Barcode) tablosuna,
    /// sonra doğrudan Item No.'ya bakar. Bulunursa true döner ve
    /// çıkış parametrelerini doldurur.
    /// </summary>
    procedure FindItemByBarcode(Barcode: Code[50]; var ItemNo: Code[20]; var VariantCode: Code[10]; var ItemDescription: Text[100]; var UnitPrice: Decimal): Boolean
    var
        ItemReference: Record "Item Reference";
        Item: Record Item;
    begin
        if Barcode = '' then
            exit(false);

        // 1) Item Reference tablosunda Barcode tipinde ara
        ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::"Bar Code");
        ItemReference.SetRange("Reference No.", Barcode);
        if ItemReference.FindFirst() then begin
            ItemNo := ItemReference."Item No.";
            VariantCode := ItemReference."Variant Code";
            if Item.Get(ItemNo) then begin
                ItemDescription := Item.Description;
                UnitPrice := Item."Unit Price";
            end;
            exit(true);
        end;

        // 2) Barkod = Ürün No. ise doğrudan Item tablosundan bul
        if Item.Get(Barcode) then begin
            ItemNo := Item."No.";
            VariantCode := '';
            ItemDescription := Item.Description;
            UnitPrice := Item."Unit Price";
            exit(true);
        end;

        exit(false);
    end;

    /// <summary>
    /// Barkod ile session'a satır ekler. Barkod çözülemezse hata verir.
    /// Kasa ekranından hızlı ürün ekleme için kullanılır.
    /// </summary>
    procedure AddLineByBarcode(SessionNo: Code[20]; Barcode: Code[50]; Qty: Decimal)
    var
        ItemNo: Code[20];
        VariantCode: Code[10];
        ItemDescription: Text[100];
        UnitPrice: Decimal;
        BarcodeNotFoundErr: Label 'Barkod bulunamadı: %1', Comment = '%1 = Barcode';
    begin
        if not FindItemByBarcode(Barcode, ItemNo, VariantCode, ItemDescription, UnitPrice) then
            Error(BarcodeNotFoundErr, Barcode);

        AddLine(SessionNo, ItemNo, VariantCode, Qty, UnitPrice, 0, ItemDescription);
    end;
}
