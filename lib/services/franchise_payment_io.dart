import 'dart:async';

import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';

Future<void> startFranchisePayment({
  required String paymentSessionId,
  required String orderId,
  required String environment,
}) async {
  final completer = Completer<void>();
  final service = CFPaymentGatewayService();
  service.setCallback(
    (String callbackOrderId) {
      if (!completer.isCompleted) completer.complete();
    },
    (CFErrorResponse errorResponse, String callbackOrderId) {
      final message = errorResponse.getMessage() ?? '';
      if (!completer.isCompleted) {
        completer.completeError(StateError(
          message.isEmpty ? 'Payment was not completed.' : message,
        ));
      }
    },
  );

  final env = environment.toLowerCase() == 'production'
      ? CFEnvironment.PRODUCTION
      : CFEnvironment.SANDBOX;
  final session = CFSessionBuilder()
      .setEnvironment(env)
      .setOrderId(orderId)
      .setPaymentSessionId(paymentSessionId)
      .build();
  final payment = CFWebCheckoutPaymentBuilder().setSession(session).build();
  service.doPayment(payment);
  await completer.future;
}
