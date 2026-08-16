page 50101 "POS Card"
{
    Caption = 'Point of Sale';
    PageType = Card;
    SourceTable = "POS Session";
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(SessionInfo)
            {
                Caption = 'Session';
                field("Session No."; Rec."Session No.") { ApplicationArea = All; Editable = false; }
                field("Terminal Code"; Rec."Terminal Code") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; Editable = false; }
                field("Cashier ID"; Rec."Cashier ID") { ApplicationArea = All; Editable = false; }
            }
            part(POSLines; "POS Line Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Session No." = field("Session No.");
            }
        }
        area(FactBoxes)
        {
            systempart(Notes; Notes) { ApplicationArea = All; }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenSession)
            {
                Caption = 'Open Session';
                ApplicationArea = All;
                Image = Open;
                trigger OnAction()
                var
                    POSMgt: Codeunit "POS Mgt.";
                begin
                    POSMgt.OpenSession(Rec."Terminal Code", 0);
                end;
            }
            action(CloseSession)
            {
                Caption = 'Close Session';
                ApplicationArea = All;
                Image = Close;
                trigger OnAction()
                var
                    POSMgt: Codeunit "POS Mgt.";
                begin
                    POSMgt.CloseSession(Rec."Session No.");
                end;
            }
        }
    }
}
