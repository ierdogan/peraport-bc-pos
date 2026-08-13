table 50100 "POS Session"
{
    Caption = 'POS Session';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Session No."; Code[20])
        {
            Caption = 'Session No.';
            DataClassification = CustomerContent;
        }
        field(2; "Terminal Code"; Code[10])
        {
            Caption = 'Terminal Code';
            DataClassification = CustomerContent;
            TableRelation = "POS Terminal".Code;
        }
        field(3; Status; Enum "POS Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(4; "Opening Date"; Date)
        {
            Caption = 'Opening Date';
            DataClassification = CustomerContent;
        }
        field(5; "Opening Time"; Time)
        {
            Caption = 'Opening Time';
            DataClassification = CustomerContent;
        }
        field(6; "Closing Date"; Date)
        {
            Caption = 'Closing Date';
            DataClassification = CustomerContent;
        }
        field(7; "Closing Time"; Time)
        {
            Caption = 'Closing Time';
            DataClassification = CustomerContent;
        }
        field(8; "Cashier ID"; Code[50])
        {
            Caption = 'Cashier ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(9; "Opening Amount"; Decimal)
        {
            Caption = 'Opening Amount';
            DataClassification = CustomerContent;
        }
        field(10; "Total Sales"; Decimal)
        {
            Caption = 'Total Sales';
            DataClassification = CustomerContent;
        }
        field(11; "Total Returns"; Decimal)
        {
            Caption = 'Total Returns';
            DataClassification = CustomerContent;
        }
        field(12; "Total Discounts"; Decimal)
        {
            Caption = 'Total Discounts';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Session No.")
        {
            Clustered = true;
        }
        key(Terminal; "Terminal Code", "Opening Date") { }
    }
}
