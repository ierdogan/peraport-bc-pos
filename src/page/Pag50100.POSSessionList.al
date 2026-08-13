page 50100 "POS Session List"
{
    Caption = 'POS Sessions';
    PageType = List;
    SourceTable = "POS Session";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Session No."; Rec."Session No.") { ApplicationArea = All; }
                field("Terminal Code"; Rec."Terminal Code") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Opening Date"; Rec."Opening Date") { ApplicationArea = All; }
                field("Cashier ID"; Rec."Cashier ID") { ApplicationArea = All; }
                field("Total Sales"; Rec."Total Sales") { ApplicationArea = All; }
            }
        }
    }
}
