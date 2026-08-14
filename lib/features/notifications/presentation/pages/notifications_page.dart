// import 'package:dental_app/core/widgets/empty_list_state.dart';
// import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
// import 'package:dental_app/features/notifications/presentation/bloc/notifications_bloc.dart';
// import 'package:dental_app/features/notifications/presentation/widgets/notification_list_item.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class NotificationsPage extends StatelessWidget {
//   const NotificationsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => NotificationsBloc(),
//       child: const _NotificationsView(),
//     );
//   }
// }

// class _NotificationsView extends StatefulWidget {
//   const _NotificationsView();

//   @override
//   State<_NotificationsView> createState() => _NotificationsViewState();
// }

// class _NotificationsViewState extends State<_NotificationsView> {
//   /// null = all, true = read, false = unread
//   bool? _isReadFilter;
//   List<Map<String, dynamic>> _items = [];
//   int _total = 0;
//   bool _loadedOnce = false;

//   bool get _hasUnread => _items.any((e) => e['isRead'] != true);

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _load());
//   }

//   Future<void> _load() async {
//     await ShimmerPreview.wait();
//     if (!mounted) return;
//     context.read<NotificationsBloc>().add(
//           LoadNotificationsRequested(isRead: _isReadFilter),
//         );
//   }

//   void _onFilterSelected(bool? value) {
//     if (_isReadFilter == value) return;
//     setState(() => _isReadFilter = value);
//     _load();
//   }

//   List<Map<String, dynamic>> _parseItems(Map<String, dynamic> data) {
//     final raw = data['items'];
//     if (raw is! List) return [];
//     return raw
//         .whereType<Map>()
//         .map((e) => Map<String, dynamic>.from(e))
//         .toList();
//   }

//   void _markOne(Map<String, dynamic> item) {
//     final id = (item['id'] ?? '').toString();
//     if (id.isEmpty) return;
//     if (item['isRead'] == true) return;
//     context.read<NotificationsBloc>().add(
//           MarkNotificationReadRequested(id: id),
//         );
//   }

//   void _markAll() {
//     if (!_hasUnread) return;
//     context.read<NotificationsBloc>().add(
//           MarkAllNotificationsReadRequested(),
//         );
//   }

//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return AppBar(
//       centerTitle: false,
//       titleSpacing: 8,
//       title: Text(
//         'Notifications'.tr(),
//         style: TextStyle(
//           color: colors.primary,
//           fontSize: 20,
//           fontWeight: FontWeight.w700,
//           letterSpacing: -0.2,
//         ),
//       ),
//       actions: [
//         Padding(
//           padding: const EdgeInsetsDirectional.only(end: 12),
//           child: Material(
//             color: _hasUnread
//                 ? colors.primary.withValues(alpha: 0.12)
//                 : colors.onSurface.withValues(alpha: 0.06),
//             borderRadius: BorderRadius.circular(22),
//             child: InkWell(
//               onTap: _hasUnread ? _markAll : null,
//               borderRadius: BorderRadius.circular(22),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.done_all_rounded,
//                       size: 16,
//                       color: _hasUnread
//                           ? colors.primary
//                           : colors.onSurface.withValues(alpha: 0.35),
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       'Mark all read'.tr(),
//                       style: TextStyle(
//                         fontSize: 12.5,
//                         fontWeight: FontWeight.w600,
//                         color: _hasUnread
//                             ? colors.primary
//                             : colors.onSurface.withValues(alpha: 0.35),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFilterChips() {
//     final colors = Theme.of(context).colorScheme;
//     final filters = <({bool? value, String label})>[
//       (value: null, label: 'All'.tr()),
//       (value: false, label: 'Unread'.tr()),
//       (value: true, label: 'Read'.tr()),
//     ];

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (_total > 0)
//             Padding(
//               padding: const EdgeInsets.only(bottom: 10, left: 2, right: 2),
//               child: Text(
//                 'Notifications count'.tr(
//                   namedArgs: {'count': '$_total'},
//                 ),
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                   color: colors.onSurface.withValues(alpha: 0.55),
//                 ),
//               ),
//             ),
//           Row(
//             children: [
//               for (var i = 0; i < filters.length; i++) ...[
//                 if (i > 0) const SizedBox(width: 8),
//                 Expanded(
//                   child: _FilterPill(
//                     label: filters[i].label,
//                     selected: _isReadFilter == filters[i].value,
//                     onTap: () => _onFilterSelected(filters[i].value),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return Scaffold(
//       appBar: _buildAppBar(context),
//       backgroundColor: colors.surfaceContainerHighest,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: Image.asset(
//                 'assets/backgrounds/background5.png',
//                 color: colors.primary,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             BlocConsumer<NotificationsBloc, NotificationsState>(
//               listener: (context, state) {
//                 if (state is NotificationsListSuccess) {
//                   setState(() {
//                     _items = _parseItems(state.data);
//                     final total = state.data['total'];
//                     _total = total is int
//                         ? total
//                         : int.tryParse('$total') ?? _items.length;
//                     _loadedOnce = true;
//                   });
//                 } else if (state is NotificationsListFailure && _loadedOnce) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(state.errMessage)),
//                   );
//                 } else if (state is MarkAllReadSuccess) {
//                   setState(() {
//                     _items =
//                         _items.map((e) => {...e, 'isRead': true}).toList();
//                   });
//                   _load();
//                 } else if (state is MarkOneReadSuccess) {
//                   setState(() {
//                     _items = _items.map((e) {
//                       if ('${e['id']}' == state.id) {
//                         return {...e, 'isRead': true};
//                       }
//                       return e;
//                     }).toList();
//                   });
//                 } else if (state is NotificationsActionFailure) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(state.errMessage)),
//                   );
//                 }
//               },
//               builder: (context, state) {
//                 final loading = state is NotificationsListLoading ||
//                     (state is NotificationsInitial && !_loadedOnce);

//                 if (loading) {
//                   return Column(
//                     children: [
//                       _buildFilterChips(),
//                       const Expanded(child: NotificationsListShimmer()),
//                     ],
//                   );
//                 }

//                 if (state is NotificationsListFailure && !_loadedOnce) {
//                   return Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(24),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(state.errMessage, textAlign: TextAlign.center),
//                           const SizedBox(height: 16),
//                           ElevatedButton(
//                             onPressed: _load,
//                             child: Text('Retry'.tr()),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }

//                 return Column(
//                   children: [
//                     _buildFilterChips(),
//                     Expanded(
//                       child: _items.isEmpty
//                           ? EmptyListState(
//                               message: 'No notifications'.tr(),
//                             )
//                           : RefreshIndicator(
//                               color: colors.primary,
//                               onRefresh: _load,
//                               child: ListView.builder(
//                                 padding: const EdgeInsets.fromLTRB(
//                                   16,
//                                   4,
//                                   16,
//                                   24,
//                                 ),
//                                 itemCount: _items.length,
//                                 itemBuilder: (context, index) {
//                                   final item = _items[index];
//                                   return NotificationListItem(
//                                     title: (item['title'] ?? '').toString(),
//                                     body: (item['body'] ?? '').toString(),
//                                     createdAt: item['createdAt']?.toString(),
//                                     isRead: item['isRead'] == true,
//                                     onTap: () => _markOne(item),
//                                   );
//                                 },
//                               ),
//                             ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _FilterPill extends StatelessWidget {
//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   const _FilterPill({
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return Material(
//       color: selected ? colors.primary : colors.surface.withValues(alpha: 0.9),
//       borderRadius: BorderRadius.circular(22),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(22),
//         child: Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(22),
//             border: Border.all(
//               color: selected
//                   ? colors.primary
//                   : colors.outlineVariant.withValues(alpha: 0.4),
//             ),
//           ),
//           child: Text(
//             label,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: selected
//                   ? colors.onPrimary
//                   : colors.onSurface.withValues(alpha: 0.72),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:dental_app/core/widgets/empty_list_state.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:dental_app/features/notifications/presentation/widgets/notification_list_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsBloc(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatefulWidget {
  const _NotificationsView();

  @override
  State<_NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<_NotificationsView> {
  /// null = all, true = read, false = unread
  bool? _isReadFilter;
  List<Map<String, dynamic>> _items = [];
  int _total = 0;
  bool _loadedOnce = false;

  bool get _hasUnread => _items.any((e) => e['isRead'] != true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    await ShimmerPreview.wait();
    if (!mounted) return;
    context.read<NotificationsBloc>().add(
          LoadNotificationsRequested(isRead: _isReadFilter),
        );
  }

  void _onFilterSelected(bool? value) {
    if (_isReadFilter == value) return;
    setState(() => _isReadFilter = value);
    _load();
  }

  List<Map<String, dynamic>> _parseItems(Map<String, dynamic> data) {
    final raw = data['items'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  void _markOne(Map<String, dynamic> item) {
    final id = (item['id'] ?? '').toString();
    if (id.isEmpty) return;
    if (item['isRead'] == true) return;
    context.read<NotificationsBloc>().add(
          MarkNotificationReadRequested(id: id),
        );
  }

  void _markAll() {
    if (!_hasUnread) return;
    context.read<NotificationsBloc>().add(
          MarkAllNotificationsReadRequested(),
        );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AppBar(
      centerTitle: false,
      titleSpacing: 20,
      title: Text(
        'Notifications'.tr(),
        style: TextStyle(
          color: colors.primary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 16),
          child: _MarkAllButton(
            enabled: _hasUnread,
            onTap: _markAll,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    final filters = <({bool? value, String label})>[
      (value: null, label: 'All'.tr()),
      (value: false, label: 'Unread'.tr()),
      (value: true, label: 'Read'.tr()),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
      child: _SegmentedFilter(
        filters: filters,
        selected: _isReadFilter,
        onChanged: _onFilterSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: colors.surfaceContainerHighest,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/backgrounds/background5.png',
                color: colors.primary,
                fit: BoxFit.cover,
              ),
            ),
            BlocConsumer<NotificationsBloc, NotificationsState>(
              listener: (context, state) {
                if (state is NotificationsListSuccess) {
                  setState(() {
                    _items = _parseItems(state.data);
                    final total = state.data['total'];
                    _total = total is int
                        ? total
                        : int.tryParse('$total') ?? _items.length;
                    _loadedOnce = true;
                  });
                } else if (state is NotificationsListFailure && _loadedOnce) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errMessage)),
                  );
                } else if (state is MarkAllReadSuccess) {
                  setState(() {
                    _items =
                        _items.map((e) => {...e, 'isRead': true}).toList();
                  });
                  _load();
                } else if (state is MarkOneReadSuccess) {
                  setState(() {
                    _items = _items.map((e) {
                      if ('${e['id']}' == state.id) {
                        return {...e, 'isRead': true};
                      }
                      return e;
                    }).toList();
                  });
                } else if (state is NotificationsActionFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errMessage)),
                  );
                }
              },
              builder: (context, state) {
                final loading = state is NotificationsListLoading ||
                    (state is NotificationsInitial && !_loadedOnce);

                if (loading) {
                  return Column(
                    children: [
                      _buildFilterBar(),
                      const Expanded(child: NotificationsListShimmer()),
                    ],
                  );
                }

                if (state is NotificationsListFailure && !_loadedOnce) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.errMessage, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _load,
                            child: Text('Retry'.tr()),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    _buildFilterBar(),
                    Expanded(
                      child: _items.isEmpty
                          ? EmptyListState(
                              message: 'No notifications'.tr(),
                            )
                          : RefreshIndicator(
                              color: colors.primary,
                              onRefresh: _load,
                              child: ListView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  4,
                                  16,
                                  24,
                                ),
                                itemCount: _items.length,
                                itemBuilder: (context, index) {
                                  final item = _items[index];
                                  return NotificationListItem(
                                    title: (item['title'] ?? '').toString(),
                                    body: (item['body'] ?? '').toString(),
                                    createdAt: item['createdAt']?.toString(),
                                    isRead: item['isRead'] == true,
                                    onTap: () => _markOne(item),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// زر "تحديد الكل كمقروء" — أيقونة دائرية مضغوطة، يبهت لما ما يكون له داعي
class _MarkAllButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _MarkAllButton({required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: enabled
          ? colors.primary.withValues(alpha: 0.1)
          : colors.onSurface.withValues(alpha: 0.05),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Icon(
            Icons.done_all_rounded,
            size: 19,
            color: enabled
                ? colors.primary
                : colors.onSurface.withValues(alpha: 0.28),
          ),
        ),
      ),
    );
  }
}

/// فلتر مقسم بستايل شرائح متجاورة (segmented control) — نفس منطق تطبيقات
/// البريد والمحادثات المعروفة، أوضح وأخف بصرياً من ثلاث pills منفصلة.
class _SegmentedFilter extends StatelessWidget {
  final List<({bool? value, String label})> filters;
  final bool? selected;
  final ValueChanged<bool?> onChanged;

  const _SegmentedFilter({
    required this.filters,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? colors.surface.withValues(alpha: 0.5)
            : colors.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (final f in filters)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(f.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: selected == f.value ? colors.surface : null,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: selected == f.value
                        ? [
                            BoxShadow(
                              color:
                                  colors.shadow.withValues(alpha: isDark ? 0.3 : 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    f.label,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight:
                          selected == f.value ? FontWeight.w700 : FontWeight.w500,
                      color: selected == f.value
                          ? colors.primary
                          : colors.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}