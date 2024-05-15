package uz.infinity.live_locations

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity(){
    override fun configureFlutterEngine(@NonNull flutterEngine:FlutterEngine){
        MapKitFactory.setApiKey("fb478ebd-da4d-4a7c-979b-d8b3503d09ae")
        super.configureFlutterEngine(flutterEngine)
    }
}
