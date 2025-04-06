import 'package:flutter/material.dart';
import 'dart:ui';

enum NotificationType { success, error, warning, info }

class AdvancedNotification extends StatelessWidget {
  final String message;
  final String? title;
  final NotificationType type;
  final Duration duration;
  final VoidCallback? onTap;
  final Widget? leadingIcon;
  final Widget? trailingAction;
  final bool showProgress;
  final AnimationStyle animationStyle;

  const AdvancedNotification({
    Key? key,
    required this.message,
    this.title,
    this.type = NotificationType.info,
    this.duration = const Duration(seconds: 3),
    this.onTap,
    this.leadingIcon,
    this.trailingAction,
    this.showProgress = false,
    this.animationStyle = AnimationStyle.slide,
  }) : super(key: key);

  Color get backgroundColor {
    switch (type) {
      case NotificationType.success:
        return Colors.green.shade50;
      case NotificationType.error:
        return Colors.red.shade50;
      case NotificationType.warning:
        return Colors.amber.shade50;
      case NotificationType.info:
        return Colors.blue.shade50;
    }
  }

  Color get iconColor {
    switch (type) {
      case NotificationType.success:
        return Colors.green;
      case NotificationType.error:
        return Colors.red;
      case NotificationType.warning:
        return Colors.amber;
      case NotificationType.info:
        return Colors.blue;
    }
  }

  IconData get defaultIcon {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.error:
        return Icons.error_outline;
      case NotificationType.warning:
        return Icons.warning_amber_outlined;
      case NotificationType.info:
        return Icons.info_outline;
    }
  }

  void show(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
    final snackBar = _buildStyled(context);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  SnackBar _buildStyled(BuildContext context) {
    switch (animationStyle) {
      case AnimationStyle.fade:
        return _buildMaterialSnackBar(context);
      case AnimationStyle.slide:
        return _buildMaterialSnackBar(context);
      case AnimationStyle.glass:
        return _buildGlassmorphismSnackBar(context);
      case AnimationStyle.card:
        return _buildCardStyleSnackBar(context);
      case AnimationStyle.toast:
        return _buildToastStyleSnackBar(context);
    }
  }

  SnackBar _buildMaterialSnackBar(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: iconColor.withOpacity(0.3), width: 1),
      ),
      content: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            leadingIcon ?? Icon(defaultIcon, color: iconColor),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style: TextStyle(
                        color: iconColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                  Text(
                    message,
                    style: TextStyle(
                      color: iconColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (trailingAction != null) ...[
              SizedBox(width: 8),
              trailingAction!,
            ],
          ],
        ),
      ),
      duration: duration,
      action: showProgress
          ? SnackBarAction(
              label: '',
              textColor: Colors.transparent,
              onPressed: () {},
              disabledTextColor: Colors.transparent,
            )
          : null,
    );
  }

  SnackBar _buildGlassmorphismSnackBar(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withOpacity(0.2),
                  iconColor.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: iconColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: leadingIcon ?? Icon(defaultIcon, color: iconColor),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null) ...[
                          Text(
                            title!,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                        ],
                        Text(
                          message,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trailingAction != null) ...[
                    SizedBox(width: 8),
                    trailingAction!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      duration: duration,
    );
  }

  SnackBar _buildCardStyleSnackBar(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: leadingIcon ?? Icon(defaultIcon, color: iconColor, size: 30),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null) ...[
                      Text(
                        title!,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailingAction != null) ...[
                SizedBox(width: 8),
                trailingAction!,
              ] else ...[
                IconButton(
                  icon: Icon(Icons.close, color: Colors.black45),
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      duration: duration,
    );
  }

  SnackBar _buildToastStyleSnackBar(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: type == NotificationType.success
              ? Colors.green.shade400
              : type == NotificationType.error
                  ? Colors.red.shade400
                  : type == NotificationType.warning
                      ? Colors.amber.shade700
                      : Colors.blue.shade600,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leadingIcon ?? Icon(defaultIcon, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (trailingAction != null) ...[
                SizedBox(width: 8),
                trailingAction!,
              ],
            ],
          ),
        ),
      ),
      duration: duration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

enum AnimationStyle {
  slide,
  fade,
  glass,
  card,
  toast,
}

// دالة مساعدة لإظهار الإشعارات بسهولة في أي مكان في التطبيق
void showAdvancedNotification(
  BuildContext context, {
  required String message,
  String? title,
  NotificationType type = NotificationType.info,
  Duration duration = const Duration(seconds: 3),
  VoidCallback? onTap,
  Widget? leadingIcon,
  Widget? trailingAction,
  bool showProgress = false,
  AnimationStyle style = AnimationStyle.card,
}) {
  AdvancedNotification(
    message: message,
    title: title,
    type: type,
    duration: duration,
    onTap: onTap,
    leadingIcon: leadingIcon,
    trailingAction: trailingAction,
    showProgress: showProgress,
    animationStyle: style,
  ).show(context);
}