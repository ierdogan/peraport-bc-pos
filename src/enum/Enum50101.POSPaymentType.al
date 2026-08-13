enum 50101 "POS Payment Type"
{
    Extensible = true;
    Caption = 'POS Payment Type';

    value(0; Cash) { Caption = 'Cash'; }
    value(1; Card) { Caption = 'Card'; }
    value(2; Mixed) { Caption = 'Mixed'; }
    value(3; Voucher) { Caption = 'Voucher'; }
}
