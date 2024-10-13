package `in`.dimalip.coach_wear

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import `in`.dimalip.coach_wear.ui.theme.Coach_wearTheme
import kotlinx.coroutines.*
import okhttp3.*
import java.io.IOException
import java.time.Instant
import java.time.Duration

class MainActivity : ComponentActivity() {
    private val client = OkHttpClient()
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            Coach_wearTheme {
                Box(
                    contentAlignment = Alignment.Center,
                    modifier = Modifier.fillMaxSize()
                ) {
                    MainContent()
                }
            }
        }
    }
}

@Composable
fun MainContent() {
    var count by remember { mutableIntStateOf(5) }
    var isTimerRunning by remember { mutableStateOf(false) }
    var startTime by remember { mutableStateOf(Instant.now()) }

    if (isTimerRunning) {
        TimerScreen(startTime, count) {
            isTimerRunning = false
            sendWebRequest(false, count)
        }
    } else {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            FocusButton(count) {
                isTimerRunning = true
                startTime = Instant.now()
                sendWebRequest(true, count)
            }
            FocusTime(
                count = count,
                onIncrement = { if (count < 95) count += 5 },
                onDecrement = { if (count > 5) count -= 5 }
            )
        }
    }
}

@Composable
fun FocusButton(count: Int, onClick: () -> Unit) {
    TextButton(
        onClick = onClick,
        shape = RoundedCornerShape(20),
        modifier = Modifier.size(60.dp),
        colors = ButtonDefaults.buttonColors(containerColor = Color.Blue)
    ) {
        Text(
            text = "DO IT",
            color = Color.White
        )
    }
}

@Composable
fun FocusTime(count: Int, onIncrement: () -> Unit, onDecrement: () -> Unit) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        TextButton(onClick = onDecrement, modifier = Modifier.size(40.dp), colors =  ButtonDefaults.textButtonColors(
            contentColor = Color.Red, containerColor = Color.Blue
        )) {
            Text("-", color = Color.White)
        }
        Text(text = count.toString(), color = Color.White)
        TextButton(onClick = onIncrement, modifier = Modifier.size(40.dp), colors =  ButtonDefaults.textButtonColors(
            contentColor = Color.Red, containerColor = Color.Blue
        )) {
            Text("+", color = Color.White)
        }
    }
}

@Composable
fun TimerScreen(startTime: Instant, durationMinutes: Int, onTimerFinish: () -> Unit) {
    var currentTime by remember { mutableStateOf(Instant.now()) }

    LaunchedEffect(key1 = startTime) {
        while (true) {
            delay(1000)
            currentTime = Instant.now()
            if (Duration.between(startTime, currentTime).toMinutes() >= durationMinutes) {
                onTimerFinish()
                break
            }
        }
    }

    val elapsedSeconds = Duration.between(startTime, currentTime).seconds.toInt()
    val remainingSeconds = (durationMinutes * 60) - elapsedSeconds
    val minutes = remainingSeconds / 60
    val seconds = remainingSeconds % 60

    Text(
        text = String.format("%02d:%02d", minutes, seconds),
        color = Color.White,
        fontSize = 25.sp
    )
}

fun sendWebRequest(focused: Boolean, count: Int) {
    val baseUrl = BuildConfig.COACH_URL
    val url = if (focused) {
        "$baseUrl?focus=true&duration=${count * 60}"
    } else {
        "$baseUrl?focus=false"
    }

    val request = Request.Builder()
        .url(url)
        .post(RequestBody.create(null, ByteArray(0)))
        .build()

    OkHttpClient().newCall(request).enqueue(object : Callback {
        override fun onFailure(call: Call, e: IOException) {
            e.printStackTrace()
        }

        override fun onResponse(call: Call, response: Response) {
            response.use {
                if (!response.isSuccessful) throw IOException("Unexpected code $response")
                println("full resp: $response")

            }
        }
    })
}
