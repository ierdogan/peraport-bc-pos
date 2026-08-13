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

    procedure AddLine(SessionNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[10]; Qty: Decimal; UnitPrice: Decimal; DiscPct: Decimal)
    var
        POSLine: Record "POS Line";
        Item: Record Item;
        LastLineNo: Integer;
    begin
        POSLine.SetRange("Session No.", SessionNo);
        if POSLine.FindLast() then
            LastLineNo := POSLine."Line No."
        else
            LastLineNo := 0;

        Item.Get(ItemNo);
        POSLine.Init();
        POSLine."Session No." := SessionNo;
        POSLine."Line No." := LastLineNo + 10000;
        POSLine."Item No." := ItemNo;
        POSLine.Description := Item.Description;
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
}
