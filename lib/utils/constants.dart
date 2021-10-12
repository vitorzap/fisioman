class Constants {
  // Client screen options
  static const String PAYMENTS = 'Pagamentos';
  static const String SESSIONS = 'Sessões';

  static const String DELETE = 'Excluir';
  static const String SCHEDULE = 'Programar pagamento';
  static const String NOSCHEDULE = 'Não Programar';

  // Client screen options list
  static const List<String> CLIENT_SCREEN_OPTIONS = <String>[
    PAYMENTS,
    SESSIONS
  ];

  // Session screen options list
  static const List<String> SESSION_SCREEN_OPTIONS_FORESEEN = <String>[DELETE];
  static const List<String> SESSION_SCREEN_OPTIONS_NOTPAID = <String>[SCHEDULE];
  static const List<String> SESSION_SCREEN_OPTIONS_TOSCHEDULE = <String>[
    NOSCHEDULE
  ];
}
