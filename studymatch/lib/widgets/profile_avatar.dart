import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Drop-in replacement for any profile photo circle in the app.
/// Normalizes any backend profilePhotoUrl value so it can be fetched via
/// the API's `serve_photo.php` endpoint on both web and native.
///
/// Supported formats:
///   - bare filename: "profile_123_456.png"
///   - relative path: "uploads/profiles/profile_123_456.png"
///   - full url: "http://localhost/.../serve_photo.php?file=profile_123_456.png"
///
/// This keeps all profile avatar screens aligned and avoids stale cached
/// images by appending a timestamp query parameter.
class ProfileAvatar extends StatefulWidget {
  final String? photoUrl;
  final String displayName;
  final double size;
  final Color? borderColor;
  final double borderWidth;
  final Color gradientStart;
  final Color gradientEnd;

  const ProfileAvatar({
    super.key,
    required this.photoUrl,
    required this.displayName,
    this.size = 88,
    this.borderColor,
    this.borderWidth = 0,
    this.gradientStart = const Color(0xFF6C63FF),
    this.gradientEnd = const Color(0xFFa78bfa),
  });

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  late String _imageCacheKey;

  static String get _apiBase => kIsWeb
      ? 'http://localhost/StudyMatch/studymatch-api'
      : 'http://192.168.254.111/StudyMatch/studymatch-api';

  @override
  void initState() {
    super.initState();
    _updateImageCacheKey();
  }

  @override
  void didUpdateWidget(ProfileAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photoUrl != widget.photoUrl) {
      if (oldWidget.photoUrl != null && oldWidget.photoUrl!.isNotEmpty) {
        final oldUrl = _buildSafeUrl(oldWidget.photoUrl!);
        if (oldUrl.isNotEmpty) {
          imageCache.evict(
            Uri.parse(oldUrl),
            includeLive: true,
          );
        }
      }
      _updateImageCacheKey();
    }
  }

  void _updateImageCacheKey() {
    _imageCacheKey = widget.photoUrl?.hashCode.toString() ?? 'no-photo';
  }

  String _buildSafeUrl(String? photoUrl) {
    if (photoUrl == null || photoUrl.isEmpty) return '';

    String url = photoUrl.trim();
    final uri = Uri.tryParse(url);

    if (!url.startsWith('http')) {
      final fileName = url.split('/').last;
      url = '$_apiBase/serve_photo.php?file=${Uri.encodeComponent(fileName)}';
    } else if (uri != null) {
      final fileName = uri.queryParameters['file'] ??
          (uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '');
      if (fileName.isNotEmpty) {
        url = '$_apiBase/serve_photo.php?file=${Uri.encodeComponent(fileName)}';
      }
    }

    final parsed = Uri.tryParse(url);
    if (parsed != null) {
      url = parsed.replace(queryParameters: {
        ...parsed.queryParameters,
        '_t': DateTime.now().millisecondsSinceEpoch.toString(),
      }).toString();
    }

    return url;
  }

  String get _initial =>
      widget.displayName.isNotEmpty ? widget.displayName[0].toUpperCase() : 'U';

  Widget _buildInitials() {
    return Center(
      child: Text(
        _initial,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: widget.size * 0.4,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    return LayoutBuilder(builder: (context, _) {
      final dpr = MediaQuery.of(context).devicePixelRatio;
      final cacheSize = (widget.size * dpr).toInt();
      return Image.network(
        url,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
        cacheHeight: cacheSize,
        cacheWidth: cacheSize,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(
            color: widget.gradientStart.withOpacity(0.2),
            child: Center(
              child: SizedBox(
                width: widget.size * 0.3,
                height: widget.size * 0.3,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: widget.gradientStart,
                ),
              ),
            ),
          );
        },
        errorBuilder: (_, error, ___) {
          debugPrint('ProfileAvatar image error: $error\n  URL: $url');
          return _buildInitials();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final url = _buildSafeUrl(widget.photoUrl);
    final hasPhoto = url.isNotEmpty;

    return Container(
      key: ValueKey(_imageCacheKey),
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        gradient: hasPhoto
            ? null
            : LinearGradient(
                colors: [widget.gradientStart, widget.gradientEnd]),
        shape: BoxShape.circle,
        border: widget.borderColor != null
            ? Border.all(color: widget.borderColor!, width: widget.borderWidth)
            : null,
      ),
      child: ClipOval(
        child: hasPhoto ? _buildImage(url) : _buildInitials(),
      ),
    );
  }
}
