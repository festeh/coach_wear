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
import `in`.dimalip.coach_wear.ui.theme.Coach_wearTheme
import kotlinx.coroutines.delay

class MainActivity : ComponentActivity() {
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

    if (isTimerRunning) {
        TimerScreen(count) { isTimerRunning = false }
    } else {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            FocusButton(count) { isTimerRunning = true }
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
fun TimerScreen(initialMinutes: Int, onTimerFinish: () -> Unit) {
    var remainingSeconds by remember { mutableIntStateOf(initialMinutes * 60) }

    LaunchedEffect(key1 = remainingSeconds) {
        if (remainingSeconds > 0) {
            delay(1000)
            remainingSeconds--
        } else {
            onTimerFinish()
        }
    }

    val minutes = remainingSeconds / 60
    val seconds = remainingSeconds % 60

    Text(
        text = String.format("%02d:%02d", minutes, seconds),
        color = Color.White
    )
}
