package uz.infinity.live_locations

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity(){
    override fun configureFlutterEngine(@NonNull flutterEngine:FlutterEngine){
        ////add your api key
        MapKitFactory.setApiKey("")
        super.configureFlutterEngine(flutterEngine)
    }
}
