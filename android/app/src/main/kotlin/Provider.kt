//import android.app.Application
//import android.content.Context
//import android.provider.Settings
//
//enum class ProviderStatus(val value: Boolean) {
//    READY(true),
//    NOT_READY(false)
//}
//
//private class Provide(val appContext: Context) {
//    var status: ProviderStatus= ProviderStatus.NOT_READY
//    val contentResolver = appContext.contentResolver
//}
//
//object Provider {
//    private var provide: Provide? = null
//
//    fun init(applicationContext: Context) {
//        if(provide?.status == ProviderStatus.READY) {
//            return
//        } else {
//            provide = Provide(applicationContext)
//            provide!!.status = ProviderStatus.READY
//        }
//    }
//
//    fun provideApplicationContext() = provide?.appContext?.applicationContext
//    fun provideContentResolver() = provide?.contentResolver
//}