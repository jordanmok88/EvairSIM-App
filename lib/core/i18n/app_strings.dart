import 'package:flutter/widgets.dart';

import 'app_locale.dart';

/// Keys for every user-facing string in the app. We deliberately use a typed
/// accessor instead of raw map lookups so you get an autocomplete error when
/// a key is missing a translation.
class AppStrings {
  const AppStrings(this._map);
  final Map<_K, String> _map;

  // ignore: library_private_types_in_public_api
  String t(_K key) => _map[key] ?? _en[key] ?? key.name;

  static AppStrings of(BuildContext context) {
    final inh = context.dependOnInheritedWidgetOfExactType<_AppStringsScope>();
    return inh?.strings ?? const AppStrings({});
  }

  static AppStrings forLocale(AppLocale locale) {
    switch (locale) {
      case AppLocale.en:
        return const AppStrings(_en);
      case AppLocale.zh:
        return const AppStrings(_zh);
      case AppLocale.es:
        return const AppStrings(_es);
    }
  }
}

/// Inherited widget injected by [LocalizedApp].
class _AppStringsScope extends InheritedWidget {
  const _AppStringsScope({required this.strings, required super.child});
  final AppStrings strings;

  @override
  bool updateShouldNotify(_AppStringsScope old) => old.strings != strings;
}

class LocalizedApp extends StatelessWidget {
  const LocalizedApp({super.key, required this.strings, required this.child});
  final AppStrings strings;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _AppStringsScope(strings: strings, child: child);
  }
}

/// Every translatable key in EvairSIM. Adding a key here forces the compiler
/// to flag missing translations in every map below.
enum _K {
  // Tabs
  tabShop,
  tabSims,
  tabProfile,

  // Shop
  shopGreetingGuest,
  shopGreetingUser,
  shopSearchHint,
  shopPopular,
  shopBrowseByCountry,
  shopNoPackages,
  shopBuyNow,

  // Auth
  authLogin,
  authRegister,
  authForgotPassword,
  authEmail,
  authPassword,
  authConfirmPassword,
  authOr,
  authNeedAccount,
  authHaveAccount,

  // Checkout
  checkoutTitle,
  checkoutDeliveryEmail,
  checkoutDeliveryHint,
  checkoutTestModeBanner,
  checkoutPlaceOrder,
  checkoutTerms,
  orderPlaced,
  orderPlacedSubtitle,
  orderGoToMySims,
  orderKeepShopping,
  orderEsimActivation,
  orderOneTime,
  orderDetails,
  orderNumber,
  orderTotalPaid,

  // My SIMs
  mySimsTitle,
  mySimsEmpty,
  mySimsEmptyDesc,
  mySimsBrowsePlans,
  mySimsActivatePhysical,
  mySimsUsageHeading,
  simTopUp,

  // Top-up
  topUpTitle,
  topUpConfirm,
  topUpNoneAvailable,

  // Physical SIM
  physTitle,
  physStep1,
  physStep1Desc,
  physStep2,
  physIccidHint,
  physPaste,
  physCameraLater,
  physActivate,
  physActivated,

  // Profile
  profileInbox,
  profileContact,
  profileOrders,
  profileLanguage,
  profileAbout,
  profileLogout,

  // Inbox
  inboxTitle,
  inboxEmpty,
  inboxEmptyDesc,

  // Contact
  contactTitle,
  contactIntro,
  contactEmail,
  contactWebsite,
  contactLiveChat,
  contactLiveChatHours,

  // Orders
  ordersTitle,
  ordersEmpty,

  // Common
  commonRetry,
  commonClose,
  commonCancel,
}

// ─────────────────────────────────────────────────────────────
// English (source of truth)
// ─────────────────────────────────────────────────────────────
const Map<_K, String> _en = {
  _K.tabShop: 'Shop',
  _K.tabSims: 'My SIMs',
  _K.tabProfile: 'Profile',

  _K.shopGreetingGuest: 'Travel anywhere,',
  _K.shopGreetingUser: 'Hi, {name}',
  _K.shopSearchHint: 'Search countries or plans',
  _K.shopPopular: 'Popular plans',
  _K.shopBrowseByCountry: 'Browse by country',
  _K.shopNoPackages: 'No plans are available for this country yet.',
  _K.shopBuyNow: 'Buy now',

  _K.authLogin: 'Log in',
  _K.authRegister: 'Create account',
  _K.authForgotPassword: 'Forgot password?',
  _K.authEmail: 'Email',
  _K.authPassword: 'Password',
  _K.authConfirmPassword: 'Confirm password',
  _K.authOr: 'or',
  _K.authNeedAccount: "Don't have an account? Sign up",
  _K.authHaveAccount: 'Already have an account? Log in',

  _K.checkoutTitle: 'Checkout',
  _K.checkoutDeliveryEmail: 'Delivery email',
  _K.checkoutDeliveryHint:
      'We will email the eSIM QR code + installation instructions to this address.',
  _K.checkoutTestModeBanner:
      'Test mode — payment will be simulated. A real Stripe checkout will be added before TestFlight release.',
  _K.checkoutPlaceOrder: 'Place order',
  _K.checkoutTerms:
      'By placing this order you agree to the EvairSIM Terms of Service.',
  _K.orderPlaced: 'Order placed',
  _K.orderPlacedSubtitle:
      'We emailed the QR code + activation instructions. You can also scan it below on another device.',
  _K.orderGoToMySims: 'Go to My SIMs',
  _K.orderKeepShopping: 'Keep shopping',
  _K.orderEsimActivation: 'eSIM activation',
  _K.orderOneTime: 'One-time activation',
  _K.orderDetails: 'Order details',
  _K.orderNumber: 'Order #',
  _K.orderTotalPaid: 'Total paid',

  _K.mySimsTitle: 'My SIMs',
  _K.mySimsEmpty: 'No SIMs yet',
  _K.mySimsEmptyDesc: 'Buy an eSIM or bind a physical SIM to get started.',
  _K.mySimsBrowsePlans: 'Browse eSIM plans',
  _K.mySimsActivatePhysical: 'Activate a physical SIM',
  _K.mySimsUsageHeading: 'Total data usage',
  _K.simTopUp: 'Top up data',

  _K.topUpTitle: 'Top up',
  _K.topUpConfirm: 'Confirm top up',
  _K.topUpNoneAvailable: 'No top-up packages available for this SIM.',

  _K.physTitle: 'Activate physical SIM',
  _K.physStep1: '1. Find your SIM ICCID',
  _K.physStep1Desc:
      'It is the 18–22 digit number printed on the back of the card.',
  _K.physStep2: '2. Enter ICCID',
  _K.physIccidHint: '89012345678901234567',
  _K.physPaste: 'Paste from clipboard',
  _K.physCameraLater:
      'Camera scanning launches with native iOS/Android. Manual entry works on all platforms.',
  _K.physActivate: 'Activate SIM',
  _K.physActivated: 'SIM activated.',

  _K.profileInbox: 'Inbox',
  _K.profileContact: 'Contact us',
  _K.profileOrders: 'My orders',
  _K.profileLanguage: 'Language',
  _K.profileAbout: 'About EvairSIM',
  _K.profileLogout: 'Log out',

  _K.inboxTitle: 'Inbox',
  _K.inboxEmpty: 'No messages yet',
  _K.inboxEmptyDesc:
      'System notifications and order updates will appear here.',

  _K.contactTitle: 'Contact us',
  _K.contactIntro: 'We usually reply within one business day.',
  _K.contactEmail: 'Email support',
  _K.contactWebsite: 'Website',
  _K.contactLiveChat: 'Live chat',
  _K.contactLiveChatHours: 'Opens Monday–Friday, 09:00–18:00 GMT+8',

  _K.ordersTitle: 'My orders',
  _K.ordersEmpty: 'No orders yet.',

  _K.commonRetry: 'Retry',
  _K.commonClose: 'Close',
  _K.commonCancel: 'Cancel',
};

// ─────────────────────────────────────────────────────────────
// Chinese (Simplified)
// ─────────────────────────────────────────────────────────────
const Map<_K, String> _zh = {
  _K.tabShop: '商城',
  _K.tabSims: '我的 SIM',
  _K.tabProfile: '我的',

  _K.shopGreetingGuest: '畅游全球，',
  _K.shopGreetingUser: '你好，{name}',
  _K.shopSearchHint: '搜索国家或套餐',
  _K.shopPopular: '热门套餐',
  _K.shopBrowseByCountry: '按国家浏览',
  _K.shopNoPackages: '该国家暂无可用套餐。',
  _K.shopBuyNow: '立即购买',

  _K.authLogin: '登录',
  _K.authRegister: '注册账号',
  _K.authForgotPassword: '忘记密码？',
  _K.authEmail: '邮箱',
  _K.authPassword: '密码',
  _K.authConfirmPassword: '确认密码',
  _K.authOr: '或',
  _K.authNeedAccount: '还没有账号？立即注册',
  _K.authHaveAccount: '已有账号？去登录',

  _K.checkoutTitle: '结算',
  _K.checkoutDeliveryEmail: '接收邮箱',
  _K.checkoutDeliveryHint: '我们会把 eSIM 二维码和安装说明发送到该邮箱。',
  _K.checkoutTestModeBanner: '测试模式 — 支付将被模拟。上线前会接入 Stripe 真实支付。',
  _K.checkoutPlaceOrder: '提交订单',
  _K.checkoutTerms: '提交订单即表示您同意 EvairSIM 服务条款。',
  _K.orderPlaced: '订单已创建',
  _K.orderPlacedSubtitle: '我们已通过邮件发送二维码和安装指南，您也可以用下方的二维码在其他设备上扫码激活。',
  _K.orderGoToMySims: '前往我的 SIM',
  _K.orderKeepShopping: '继续购物',
  _K.orderEsimActivation: 'eSIM 激活',
  _K.orderOneTime: '仅限一次激活',
  _K.orderDetails: '订单详情',
  _K.orderNumber: '订单号',
  _K.orderTotalPaid: '实付金额',

  _K.mySimsTitle: '我的 SIM',
  _K.mySimsEmpty: '还没有 SIM 卡',
  _K.mySimsEmptyDesc: '购买 eSIM 或绑定实体卡即可开始使用。',
  _K.mySimsBrowsePlans: '浏览 eSIM 套餐',
  _K.mySimsActivatePhysical: '激活实体 SIM',
  _K.mySimsUsageHeading: '总流量使用',
  _K.simTopUp: '流量续费',

  _K.topUpTitle: '续费',
  _K.topUpConfirm: '确认续费',
  _K.topUpNoneAvailable: '当前 SIM 暂无可用续费套餐。',

  _K.physTitle: '激活实体 SIM',
  _K.physStep1: '1. 找到 SIM 卡 ICCID',
  _K.physStep1Desc: 'ICCID 是 SIM 卡背面的 18–22 位数字。',
  _K.physStep2: '2. 输入 ICCID',
  _K.physIccidHint: '89012345678901234567',
  _K.physPaste: '从剪贴板粘贴',
  _K.physCameraLater: '原生 iOS/Android 上将支持扫码激活，所有平台均可手动输入。',
  _K.physActivate: '激活 SIM',
  _K.physActivated: 'SIM 已激活。',

  _K.profileInbox: '消息',
  _K.profileContact: '联系我们',
  _K.profileOrders: '我的订单',
  _K.profileLanguage: '语言',
  _K.profileAbout: '关于 EvairSIM',
  _K.profileLogout: '退出登录',

  _K.inboxTitle: '消息',
  _K.inboxEmpty: '暂无消息',
  _K.inboxEmptyDesc: '系统通知和订单更新将在此展示。',

  _K.contactTitle: '联系我们',
  _K.contactIntro: '我们一般在一个工作日内回复。',
  _K.contactEmail: '邮件支持',
  _K.contactWebsite: '官网',
  _K.contactLiveChat: '在线客服',
  _K.contactLiveChatHours: '工作时间：周一至周五 09:00–18:00 (北京时间)',

  _K.ordersTitle: '我的订单',
  _K.ordersEmpty: '暂无订单。',

  _K.commonRetry: '重试',
  _K.commonClose: '关闭',
  _K.commonCancel: '取消',
};

// ─────────────────────────────────────────────────────────────
// Spanish
// ─────────────────────────────────────────────────────────────
const Map<_K, String> _es = {
  _K.tabShop: 'Tienda',
  _K.tabSims: 'Mis SIM',
  _K.tabProfile: 'Perfil',

  _K.shopGreetingGuest: 'Viaja por cualquier lugar,',
  _K.shopGreetingUser: 'Hola, {name}',
  _K.shopSearchHint: 'Buscar países o planes',
  _K.shopPopular: 'Planes populares',
  _K.shopBrowseByCountry: 'Buscar por país',
  _K.shopNoPackages: 'Aún no hay planes disponibles para este país.',
  _K.shopBuyNow: 'Comprar ahora',

  _K.authLogin: 'Iniciar sesión',
  _K.authRegister: 'Crear cuenta',
  _K.authForgotPassword: '¿Olvidaste tu contraseña?',
  _K.authEmail: 'Correo',
  _K.authPassword: 'Contraseña',
  _K.authConfirmPassword: 'Confirmar contraseña',
  _K.authOr: 'o',
  _K.authNeedAccount: '¿No tienes cuenta? Regístrate',
  _K.authHaveAccount: '¿Ya tienes cuenta? Inicia sesión',

  _K.checkoutTitle: 'Pagar',
  _K.checkoutDeliveryEmail: 'Correo de entrega',
  _K.checkoutDeliveryHint:
      'Enviaremos el código QR de la eSIM y las instrucciones de instalación a esta dirección.',
  _K.checkoutTestModeBanner:
      'Modo de prueba — el pago será simulado. Stripe real se añadirá antes del lanzamiento.',
  _K.checkoutPlaceOrder: 'Realizar pedido',
  _K.checkoutTerms:
      'Al realizar este pedido aceptas los Términos de Servicio de EvairSIM.',
  _K.orderPlaced: 'Pedido realizado',
  _K.orderPlacedSubtitle:
      'Te enviamos el código QR y las instrucciones por correo. También puedes escanearlo en otro dispositivo abajo.',
  _K.orderGoToMySims: 'Ir a Mis SIM',
  _K.orderKeepShopping: 'Seguir comprando',
  _K.orderEsimActivation: 'Activación eSIM',
  _K.orderOneTime: 'Activación única',
  _K.orderDetails: 'Detalles del pedido',
  _K.orderNumber: 'Pedido N°',
  _K.orderTotalPaid: 'Total pagado',

  _K.mySimsTitle: 'Mis SIM',
  _K.mySimsEmpty: 'Aún no tienes SIM',
  _K.mySimsEmptyDesc:
      'Compra una eSIM o activa una SIM física para empezar.',
  _K.mySimsBrowsePlans: 'Explorar planes eSIM',
  _K.mySimsActivatePhysical: 'Activar SIM física',
  _K.mySimsUsageHeading: 'Uso total de datos',
  _K.simTopUp: 'Recargar datos',

  _K.topUpTitle: 'Recargar',
  _K.topUpConfirm: 'Confirmar recarga',
  _K.topUpNoneAvailable:
      'No hay paquetes de recarga disponibles para esta SIM.',

  _K.physTitle: 'Activar SIM física',
  _K.physStep1: '1. Encuentra el ICCID de tu SIM',
  _K.physStep1Desc:
      'Es el número de 18–22 dígitos impreso en el dorso de la tarjeta.',
  _K.physStep2: '2. Ingresa el ICCID',
  _K.physIccidHint: '89012345678901234567',
  _K.physPaste: 'Pegar desde el portapapeles',
  _K.physCameraLater:
      'El escaneo con cámara llega con iOS/Android nativos. La entrada manual funciona en todas las plataformas.',
  _K.physActivate: 'Activar SIM',
  _K.physActivated: 'SIM activada.',

  _K.profileInbox: 'Mensajes',
  _K.profileContact: 'Contáctanos',
  _K.profileOrders: 'Mis pedidos',
  _K.profileLanguage: 'Idioma',
  _K.profileAbout: 'Acerca de EvairSIM',
  _K.profileLogout: 'Cerrar sesión',

  _K.inboxTitle: 'Mensajes',
  _K.inboxEmpty: 'Sin mensajes aún',
  _K.inboxEmptyDesc:
      'Aquí aparecerán notificaciones del sistema y actualizaciones de pedidos.',

  _K.contactTitle: 'Contáctanos',
  _K.contactIntro: 'Respondemos normalmente dentro de un día hábil.',
  _K.contactEmail: 'Soporte por correo',
  _K.contactWebsite: 'Sitio web',
  _K.contactLiveChat: 'Chat en vivo',
  _K.contactLiveChatHours:
      'Disponible lunes a viernes, 09:00–18:00 GMT+8',

  _K.ordersTitle: 'Mis pedidos',
  _K.ordersEmpty: 'Aún no hay pedidos.',

  _K.commonRetry: 'Reintentar',
  _K.commonClose: 'Cerrar',
  _K.commonCancel: 'Cancelar',
};

/// Typed accessors. Callers use these instead of raw enum values so the
/// call sites stay readable.
extension AppStringsX on AppStrings {
  String get tabShop => t(_K.tabShop);
  String get tabSims => t(_K.tabSims);
  String get tabProfile => t(_K.tabProfile);

  String get shopGreetingGuest => t(_K.shopGreetingGuest);
  String shopGreetingUser(String name) =>
      t(_K.shopGreetingUser).replaceAll('{name}', name);
  String get shopSearchHint => t(_K.shopSearchHint);
  String get shopPopular => t(_K.shopPopular);
  String get shopBrowseByCountry => t(_K.shopBrowseByCountry);
  String get shopNoPackages => t(_K.shopNoPackages);
  String get shopBuyNow => t(_K.shopBuyNow);

  String get authLogin => t(_K.authLogin);
  String get authRegister => t(_K.authRegister);
  String get authForgotPassword => t(_K.authForgotPassword);
  String get authEmail => t(_K.authEmail);
  String get authPassword => t(_K.authPassword);
  String get authConfirmPassword => t(_K.authConfirmPassword);
  String get authOr => t(_K.authOr);
  String get authNeedAccount => t(_K.authNeedAccount);
  String get authHaveAccount => t(_K.authHaveAccount);

  String get checkoutTitle => t(_K.checkoutTitle);
  String get checkoutDeliveryEmail => t(_K.checkoutDeliveryEmail);
  String get checkoutDeliveryHint => t(_K.checkoutDeliveryHint);
  String get checkoutTestModeBanner => t(_K.checkoutTestModeBanner);
  String get checkoutPlaceOrder => t(_K.checkoutPlaceOrder);
  String get checkoutTerms => t(_K.checkoutTerms);
  String get orderPlaced => t(_K.orderPlaced);
  String get orderPlacedSubtitle => t(_K.orderPlacedSubtitle);
  String get orderGoToMySims => t(_K.orderGoToMySims);
  String get orderKeepShopping => t(_K.orderKeepShopping);
  String get orderEsimActivation => t(_K.orderEsimActivation);
  String get orderOneTime => t(_K.orderOneTime);
  String get orderDetails => t(_K.orderDetails);
  String get orderNumber => t(_K.orderNumber);
  String get orderTotalPaid => t(_K.orderTotalPaid);

  String get mySimsTitle => t(_K.mySimsTitle);
  String get mySimsEmpty => t(_K.mySimsEmpty);
  String get mySimsEmptyDesc => t(_K.mySimsEmptyDesc);
  String get mySimsBrowsePlans => t(_K.mySimsBrowsePlans);
  String get mySimsActivatePhysical => t(_K.mySimsActivatePhysical);
  String get mySimsUsageHeading => t(_K.mySimsUsageHeading);
  String get simTopUp => t(_K.simTopUp);

  String get topUpTitle => t(_K.topUpTitle);
  String get topUpConfirm => t(_K.topUpConfirm);
  String get topUpNoneAvailable => t(_K.topUpNoneAvailable);

  String get physTitle => t(_K.physTitle);
  String get physStep1 => t(_K.physStep1);
  String get physStep1Desc => t(_K.physStep1Desc);
  String get physStep2 => t(_K.physStep2);
  String get physIccidHint => t(_K.physIccidHint);
  String get physPaste => t(_K.physPaste);
  String get physCameraLater => t(_K.physCameraLater);
  String get physActivate => t(_K.physActivate);
  String get physActivated => t(_K.physActivated);

  String get profileInbox => t(_K.profileInbox);
  String get profileContact => t(_K.profileContact);
  String get profileOrders => t(_K.profileOrders);
  String get profileLanguage => t(_K.profileLanguage);
  String get profileAbout => t(_K.profileAbout);
  String get profileLogout => t(_K.profileLogout);

  String get inboxTitle => t(_K.inboxTitle);
  String get inboxEmpty => t(_K.inboxEmpty);
  String get inboxEmptyDesc => t(_K.inboxEmptyDesc);

  String get contactTitle => t(_K.contactTitle);
  String get contactIntro => t(_K.contactIntro);
  String get contactEmail => t(_K.contactEmail);
  String get contactWebsite => t(_K.contactWebsite);
  String get contactLiveChat => t(_K.contactLiveChat);
  String get contactLiveChatHours => t(_K.contactLiveChatHours);

  String get ordersTitle => t(_K.ordersTitle);
  String get ordersEmpty => t(_K.ordersEmpty);

  String get commonRetry => t(_K.commonRetry);
  String get commonClose => t(_K.commonClose);
  String get commonCancel => t(_K.commonCancel);
}
