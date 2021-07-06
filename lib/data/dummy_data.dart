import '../providers/clients.dart';
import '../providers/session_days.dart';

final DUMMY_CLIENTS = [
  Client(
    id: 1,
    name: 'Joao Soares Almeida e Sá',
    email: 'joaosas@hotmail.com',
    telephone: '27981904521',
    address: 'rua Maria Horta Pereira n33 Centro Vitoria ES',
    paymentFrequency: PaymentFrequency.Mensal,
  ),
  Client(
    id: 2,
    name: 'Andrea Pinheiro Lima',
    email: 'andreapila@hotmail.com',
    telephone: '27999904761',
    address: 'rua Lourde de Oliveira n33 Centro Vitoria ES',
    paymentFrequency: PaymentFrequency.Mensal,
  ),
];
