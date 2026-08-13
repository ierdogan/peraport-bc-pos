page 50102 "POS Terminal List"
{
    Caption = 'POS Terminals';
    PageType = List;
    SourceTable = "POS Terminal";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Store Code"; Rec."Store Code") { ApplicationArea = All; }
                field("Location Code"; Rec."Location Code") { ApplicationArea = All; }
                field(Active; Rec.Active) { ApplicationArea = All; }
                field("Last Session No."; Rec."Last Session No.") { ApplicationArea = All; Editable = false; }
            }
        }
    }
}
