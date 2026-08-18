table 50101 "POS Line"
{
    Caption = 'POS Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Session No."; Code[20])
        {
            Caption = 'Session No.';
            DataClassification = CustomerContent;
            TableRelation = "POS Session"."Session No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item."No.";

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                if "Item No." = '' then begin
                    Description := '';
                    "Unit Price" := 0;
                    "Variant Code" := '';
                end else
                    if Item.Get("Item No.") then begin
                        Description := Item.Description;
                        "Unit Price" := Item."Unit Price";
                    end;
                UpdateAmounts();
            end;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(5; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateAmounts();
            end;
        }
        field(7; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateAmounts();
            end;
        }
        field(8; "Discount %"; Decimal)
        {
            Caption = 'Discount %';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateAmounts();
            end;
        }
        field(9; "Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount';
            DataClassification = CustomerContent;
        }
        field(10; "Net Amount"; Decimal)
        {
            Caption = 'Net Amount';
            DataClassification = CustomerContent;
        }
        field(11; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DataClassification = CustomerContent;
        }
        field(12; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            DataClassification = CustomerContent;
        }
        field(13; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            DataClassification = CustomerContent;
        }
        field(14; "Barcode"; Code[50])
        {
            Caption = 'Barcode';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                POSMgt: Codeunit "POS Mgt.";
                ItemNo: Code[20];
                VariantCode: Code[10];
                ItemDescription: Text[100];
                Price: Decimal;
                BarcodeNotFoundErr: Label 'Barkod bulunamadı: %1', Comment = '%1 = Barcode';
            begin
                if "Barcode" = '' then
                    exit;

                if not POSMgt.FindItemByBarcode("Barcode", ItemNo, VariantCode, ItemDescription, Price) then
                    Error(BarcodeNotFoundErr, "Barcode");

                "Item No." := ItemNo;
                "Variant Code" := VariantCode;
                Description := ItemDescription;
                "Unit Price" := Price;
                if Quantity = 0 then
                    Quantity := 1;
                UpdateAmounts();
            end;
        }
    }

    keys
    {
        key(PK; "Session No.", "Line No.")
        {
            Clustered = true;
        }
        key(Item; "Item No.", "Session No.") { }
    }

    /// <summary>
    /// Satırdaki iskonto, net tutar, KDV ve toplam tutarı yeniden hesaplar.
    /// Quantity, Unit Price, Discount % veya Item No. değiştiğinde çağrılır.
    /// </summary>
    procedure UpdateAmounts()
    begin
        "Discount Amount" := Round(Quantity * "Unit Price" * "Discount %" / 100);
        "Net Amount" := Round(Quantity * "Unit Price") - "Discount Amount";
        if "VAT %" = 0 then
            "VAT %" := 20; // TODO: Item VAT posting group'tan al
        "VAT Amount" := Round("Net Amount" * "VAT %" / 100);
        "Total Amount" := "Net Amount" + "VAT Amount";
    end;
}
