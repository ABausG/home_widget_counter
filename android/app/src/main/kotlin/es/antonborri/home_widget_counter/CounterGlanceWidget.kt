package es.antonborri.home_widget_counter

import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition
import android.content.Context
import android.net.Uri
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.ColorFilter
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.action.ActionParameters
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.action.ActionCallback
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextAlign
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.actionStartActivity

class CounterGlanceWidget : GlanceAppWidget() {

  /**
   * Needed for Updating
   */
  override val stateDefinition = HomeWidgetGlanceStateDefinition()

  override suspend fun provideGlance(context: Context, id: GlanceId) {
    provideContent {
      GlanceContent(context, currentState())
    }
  }

  @Composable
  private fun GlanceContent(context: Context, currentState: HomeWidgetGlanceState) {
    val data = currentState.preferences
    val count = data.getInt("counter", 0)

    Box(modifier = GlanceModifier
        .background(Color.White)
        .padding(16.dp)
        .clickable(onClick = actionStartActivity<MainActivity>(context))) {
      Column(
          modifier = GlanceModifier.fillMaxSize(),
          verticalAlignment = Alignment.Vertical.CenterVertically,
          horizontalAlignment = Alignment.Horizontal.CenterHorizontally,
      ) {
        Text(
            "You have pushed the button this many times:",
            style = TextStyle(fontSize = 14.sp, textAlign = TextAlign.Center),
        )
        Spacer(GlanceModifier.defaultWeight())
        Text(
            count.toString(),
            style = TextStyle(fontSize = 32.sp, fontWeight = FontWeight.Bold, textAlign = TextAlign.Center),
        )
        Spacer(GlanceModifier.defaultWeight())
        Row(
            modifier = GlanceModifier.fillMaxWidth()
        ) {
          Box(
              modifier = GlanceModifier.clickable(onClick = actionRunCallback<ClearAction>())
          ) {
            Image(
                provider = ImageProvider(R.drawable.baseline_close_24), contentDescription = null,
                colorFilter = ColorFilter.tint(ColorProvider(Color.White)),
                modifier = GlanceModifier.size(32.dp).background(
                    imageProvider = ImageProvider(R.drawable.fab_shape)
                )
            )
          }
          Spacer(GlanceModifier.defaultWeight())
          Box(
              modifier = GlanceModifier.clickable(onClick = actionRunCallback<IncrementAction>())
          ) {
            Image(
                provider = ImageProvider(R.drawable.baseline_add_24), contentDescription = null,
                colorFilter = ColorFilter.tint(ColorProvider(Color.White)),
                modifier = GlanceModifier.size(32.dp).background(
                    imageProvider = ImageProvider(R.drawable.fab_shape)
                )
            )
          }
        }
      }
    }
  }
}

class IncrementAction : ActionCallback {
  override suspend fun onAction(context: Context, glanceId: GlanceId, parameters: ActionParameters) {
    val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
        context,
        Uri.parse("homeWidgetCounter://increment"))
    backgroundIntent.send()
  }
}

class ClearAction : ActionCallback {
  override suspend fun onAction(context: Context, glanceId: GlanceId, parameters: ActionParameters) {
    val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
        context,
        Uri.parse("homeWidgetCounter://clear"))
    backgroundIntent.send()
  }
}