import 'package:fivekmrun_flutter/charts/best_times_by_route_chart.dart';
import 'package:fivekmrun_flutter/charts/runs_by_route_chart.dart';
import 'package:fivekmrun_flutter/common/avatar.dart';
import 'package:fivekmrun_flutter/common/run_card.dart';
import 'package:fivekmrun_flutter/custom_icons.dart';
import 'package:fivekmrun_flutter/state/runs_resource.dart';
import 'package:fivekmrun_flutter/state/user_resource.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'charts/runs_chart.dart';
import 'common/milestone.dart';

class ProfileDashboard extends StatelessWidget {
  const ProfileDashboard({Key key}) : super(key: key);

  int nextRunsMilestone(int count) {
    if (count <= 50) {
      return 50;
    } else if (count <= 100) {
      return 100;
    } else if (count <= 250) {
      return 250;
    } else {
      return 500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserResource>(builder: (context, userResource, child) {
    final user = userResource?.value;
    final textTheme = Theme.of(context).textTheme;
    final runsResource = Provider.of<RunsResource>(context);

    final goToSettings = () {
      Navigator.of(context, rootNavigator: true).pushNamed("/settings");
    };

    final goToBarcode = () {
      Navigator.of(context, rootNavigator: true).pushNamed("/barcode");
    };

    return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(CustomIcons.barcode),
                    onPressed: goToBarcode,
                  ),
                  MilestoneTile(
                      value: (runsResource?.value?.length?.toInt() ?? 0) * 5,
                      milestone: 1250,
                      title: "Пробягано\nразстояние"),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                children: <Widget>[
                  Avatar(url: user?.avatarUrl),
                  Text(
                    user?.name ?? "",
                    style: textTheme.subhead,
                    textAlign: TextAlign.center,
                  ),
                  Text("${user?.age ?? ""}г."),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: goToSettings,
                  ),
                  MilestoneTile(
                      value: runsResource?.value?.length?.toInt() ?? 0,
                      milestone: nextRunsMilestone(runsResource?.value?.length?.toInt() ?? 0),
                      title: "Следваща\nцел"),
                ],
              ),
            ),
          ],
        ),
        if (runsResource.value == null || runsResource.value.length <= 0)
        Row(
          children: <Widget>[
            Expanded(
              child:
                  Text("Все още не сте направили първото си официално бягане"),
            )
          ],
        ),
        if (runsResource.value != null && runsResource.value.length > 0)
        Row(
          children: <Widget>[
            Expanded(
              child: RunCard(
                title: "Последно участие",
                run: runsResource.lastRun,
              ),
            ),
            Expanded(
              child: RunCard(
                title: "Най-добро участие",
                run: runsResource.bestRun,
              ),
            ),
          ],
        ),
        if (runsResource.value != null && runsResource.value.length > 0)
        Card(
          child: Container(
            height: 200,
            child: RunsChart(runs: runsResource?.value),
          ),
        ),
        if (runsResource.value != null && runsResource.value.length > 0)
        Card(
          child: Container(
              height: 200,
              child: RunsByRouteChart.withRuns(runsResource?.value)),
        ),
        if (runsResource.value != null && runsResource.value.length > 0)
        Card(
            child: Container(
                height: 200,
                child: BestTimesByRouteChart.withRuns(runsResource?.value)))
      ],
    );
    });
  }
}
