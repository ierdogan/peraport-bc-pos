table 50102 "POS Payment"
{
    Caption = 'POS Payment';
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
        field(3; "Payment Type"; Enum "POS Payment Type")
        {
            Caption = 'Payment Type';
            DataClassification = CustomerContent;
        }
        field(4; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(5; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
        }
        field(6; "Reference No."; Text[50])
        {
            Caption = 'Reference No.';
            DataClassification = CustomerContent;
        }
        field(7; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Session No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
