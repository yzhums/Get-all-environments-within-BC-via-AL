page 50105 "BC Environments"
{
    ApplicationArea = All;
    Caption = 'BC Environments';
    PageType = List;
    SourceTable = "BC Environments";
    UsageCategory = Lists;
    //Editable = false;
    InsertAllowed = false;
    //DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Application Family"; Rec."Application Family")
                {
                    ToolTip = 'Specifies the value of the Application Family field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field(State; Rec.State)
                {
                    ToolTip = 'Specifies the value of the State field.', Comment = '%';
                }
                field("Contry/Region"; Rec."Contry/Region")
                {
                    ToolTip = 'Specifies the value of the Contry/Region field.', Comment = '%';
                }
                field("Current Version"; Rec."Current Version")
                {
                    ToolTip = 'Specifies the value of the Current Version field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetEnvironments)
            {
                ApplicationArea = All;
                Caption = 'Get Environments';
                Promoted = true;
                PromotedCategory = Process;
                Image = GetLines;

                trigger OnAction()
                begin
                    Rec.GetEnvironments();
                end;
            }
        }
    }
}
