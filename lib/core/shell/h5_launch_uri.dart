import '../constants/app_constants.dart';

/// Returns [incoming] when it clearly targets the H5 customer shell on the
/// same site as [AppConstants.h5Url], preserving path, query, and **fragment**
/// (e.g. `#esim`). Otherwise returns `null`.
///
/// The native [WebViewShellPage] always used a fixed [AppConstants.h5Url]
/// (`…/app`) on cold start, which **dropped** `#esim` and `/travel-esim/jp`
/// tails from marketing deep links. Filtering here lets Universal Links /
/// HTTPS intents pass the full URL through to [InAppWebView].
Uri? filterIncomingH5ShellUri(Uri? incoming) {
  if (incoming == null) return null;
  final base = Uri.tryParse(AppConstants.h5Url);
  if (base == null) return null;

  if (incoming.scheme != 'https' && incoming.scheme != 'http') return null;
  if (!_hostsMatch(incoming.host, base.host)) return null;

  final path = incoming.path.isEmpty ? '/' : incoming.path;
  if (!path.startsWith('/app')) return null;

  return incoming;
}

String? incomingH5ShellUrlString(Uri? incoming) {
  final u = filterIncomingH5ShellUri(incoming);
  return u?.toString();
}

bool _hostsMatch(String a, String b) {
  final la = a.toLowerCase();
  final lb = b.toLowerCase();
  if (la == lb) return true;
  if (la == 'www.$lb' || lb == 'www.$la') return true;
  return false;
}
