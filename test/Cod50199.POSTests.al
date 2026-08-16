codeunit 50199 "POS Tests"
{
    Subtype = Test;

    var
        Assert: Codeunit "Assert";

    [Test]
    procedure TestOpenSession()
    var
        POSMgt: Codeunit "POS Mgt.";
        SessionNo: Code[20];
    begin
        // [GIVEN] A POS terminal exists
        // [WHEN] We open a session
        SessionNo := POSMgt.OpenSession('KASA01', 500);
        // [THEN] Session is created with Open status
        Assert.AreNotEqual('', SessionNo, 'Session No. should not be empty');
    end;
}
