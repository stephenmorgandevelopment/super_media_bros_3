package com.stephenmorgandevelopment.super_media_bros_3.mediasession;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.AssetManager;
import android.media.AudioManager;
import android.media.MediaMetadata;
import android.media.MediaMetadataRetriever;
import android.media.MediaPlayer;
import android.media.Rating;
import android.os.Build;
import android.os.Bundle;
import android.os.PowerManager;
import android.provider.MediaStore;
import android.support.v4.media.MediaBrowserCompat;
import android.support.v4.media.MediaMetadataCompat;
import android.support.v4.media.RatingCompat;
import android.support.v4.media.session.MediaSessionCompat;
import android.support.v4.media.session.PlaybackStateCompat;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;
import androidx.media.MediaBrowserServiceCompat;
import androidx.media.session.MediaButtonReceiver;

import com.stephenmorgandevelopment.super_media_bros_3.MediaRepo;
import com.stephenmorgandevelopment.super_media_bros_3.R;
import com.stephenmorgandevelopment.super_media_bros_3.models.Media;

import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.engine.plugins.service.ServiceAware;
import io.flutter.embedding.engine.plugins.service.ServicePluginBinding;

public class MusicPlayerService extends MediaBrowserServiceCompat implements ServiceAware {
    private final AssetManager assetManager = getAssets();
    private static Context applicationContext;
    private static MediaRepo repo = new MediaRepo(applicationContext.getContentResolver());
    private static PowerManager.WakeLock wakeLock;

//    String key = getAssets().lookupKeyForAsset("icons/heart.png");
//    AssetFileDescriptor fd = assetManager.openFd(key);


    private static MediaPlayer player;
    private MediaSessionCompat session;
    private static PlaybackStateCompat.Builder state;
    private static Media curPlaying;
    private static ArrayList<Media> playlist;
    private Notification notify;
    private String id = "SMBAudioPlayer";
    private static int num;
    private static int pos;
    private PendingIntent touch;
    private static boolean ready;
    private OutputChange outchanged;
    private IntentFilter intentFilter;
    private AudioManager am;
    private static String log;

    @Override
    public void onAttachedToService(@NonNull ServicePluginBinding binding) {
        applicationContext = binding.getService().getApplicationContext();
    }

    @Override
    public void onDetachedFromService() {

    }

    @Override
    public void onCreate() {
        super.onCreate();
        session = new MediaSessionCompat(this, id);
        session.setFlags(MediaSessionCompat.FLAG_HANDLES_MEDIA_BUTTONS | MediaSessionCompat.FLAG_HANDLES_TRANSPORT_CONTROLS);
        setSessionToken(session.getSessionToken());

        state = new PlaybackStateCompat.Builder();
        state.setActions(PlaybackStateCompat.ACTION_PLAY | PlaybackStateCompat.ACTION_PAUSE | PlaybackStateCompat.ACTION_FAST_FORWARD | PlaybackStateCompat.ACTION_REWIND | PlaybackStateCompat.ACTION_SKIP_TO_PREVIOUS | PlaybackStateCompat.ACTION_SKIP_TO_NEXT | PlaybackStateCompat.ACTION_STOP);
        session.setPlaybackState(state.build());

        createChannel();
        num = 735;
//        touch = PendingIntent.getActivity(getApplicationContext(), 1, new Intent(getApplicationContext(), MediaView.class).putExtra("CURRENT_FILE", curPlaying.path), 0);

        if(playlist == null) playlist = new ArrayList<>();
        player = new MediaPlayer();
        ready = false;
        outchanged = new OutputChange();
        intentFilter = new IntentFilter(AudioManager.ACTION_AUDIO_BECOMING_NOISY);
        am = (AudioManager)getSystemService(AUDIO_SERVICE);

        player.setOnPreparedListener((mp) -> {
            session.getController().getTransportControls().play();
        });

        player.setOnCompletionListener((mp) -> {
            session.getController().getTransportControls().skipToNext();
        });

        session.setCallback(new MediaSessionCompat.Callback() {
            @Override
            public void onPlay() {
                session.setActive(true);
                int res = am.requestAudioFocus(focusChangeListener, AudioManager.STREAM_MUSIC, AudioManager.AUDIOFOCUS_GAIN);
                if(res == AudioManager.AUDIOFOCUS_REQUEST_GRANTED) {
                    registerReceiver(outchanged, intentFilter);
                    session.setMetadata(genMediaMetadata(curPlaying));
                    state.setState(PlaybackStateCompat.STATE_PLAYING, player.getCurrentPosition(), 1.0f);
                    session.setPlaybackState(state.build());
                    player.start();
                    ready = true;
//                    MediaView.playerReady = true;
                    if (!wakeLock.isHeld()) wakeLock.acquire(3600000);
                    startService(new Intent(MusicPlayerService.this, MusicPlayerService.class));
                    startForeground(num, buildPlayNote());
                }
            }

            @Override
            public void onPause() {
                try {
                    unregisterReceiver(outchanged);
                } catch(Exception e) {
                    //null
                }
                player.pause();
                state.setState(PlaybackStateCompat.STATE_PAUSED, player.getCurrentPosition(), 1.0f);
                session.setPlaybackState(state.build());
                startForeground(num, buildPauseNote());
                stopForeground(false);
            }

            @Override
            public void onSkipToNext() {
                state.setState(PlaybackStateCompat.STATE_SKIPPING_TO_NEXT, player.getCurrentPosition(), 1.0f);
                session.setPlaybackState(state.build());
                toNext();
            }

            @Override
            public void onSkipToPrevious() {
                state.setState(PlaybackStateCompat.STATE_SKIPPING_TO_NEXT, player.getCurrentPosition(), 1.0f);
                session.setPlaybackState(state.build());
                toPrev();
            }

            @Override
            public void onFastForward() {
                player.pause();
                state.setState(PlaybackStateCompat.STATE_FAST_FORWARDING, player.getCurrentPosition(), 1.0f);
                session.setPlaybackState(state.build());
                player.seekTo(player.getCurrentPosition()+10000);
                session.getController().getTransportControls().play();
            }

            @Override
            public void onRewind() {
                player.pause();
                state.setState(PlaybackStateCompat.STATE_REWINDING, player.getCurrentPosition(), 1.0f);
                session.setPlaybackState(state.build());
                player.seekTo(player.getCurrentPosition()-5000);
                session.getController().getTransportControls().play();
            }

            @Override
            public void onStop() {
                try {
                    unregisterReceiver(outchanged);
                } catch(Exception e) {
                    //null
                }
                startForeground(num, buildPauseNote());
                ready = false;
//                MediaView.playerReady = false;
                state.setState(PlaybackStateCompat.STATE_STOPPED, player.getCurrentPosition(), 1.0f);
                session.setPlaybackState(state.build());
                session.setActive(false);
                player.stop();
                if(wakeLock.isHeld()) wakeLock.release();
                stopForeground(true);
                stopSelf();
            }

            @Override
            public void onSeekTo(long pos) {
                player.seekTo((int)(pos*1000));
            }
        });

        try {
            player.setDataSource(applicationContext, curPlaying.getUri());
            player.prepare();
        } catch (Exception e) {
            //none yet
        }
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        MediaButtonReceiver.handleIntent(session, intent);
        return START_STICKY;
    }

    @Override
    public boolean stopService(Intent name) {
        try {unregisterReceiver(outchanged);}
        catch (Exception e) {}
//        MediaView.playerReady = false;
        playlist = null;
        player.release();
        player = null;
        session.release();
        session = null;
        notify = null;
        return super.stopService(name);
    }



    @Nullable
    @Override
    public BrowserRoot onGetRoot(@NonNull String clientPackageName, int clientUid, @Nullable Bundle rootHints) {
        return new BrowserRoot("no_root", null);
    }

    @Override
    public void onLoadChildren(@NonNull String parentId, @NonNull Result<List<MediaBrowserCompat.MediaItem>> result) {

    }

    private MediaMetadataCompat genMediaMetadata(Media media) {
        log = null;
        MediaMetadataCompat.Builder builder = new MediaMetadataCompat.Builder();
//        MediaMetadataRetriever pull = new MediaMetadataRetriever();
//        pull.setDataSource(curPlaying.path);
        builder.putString(MediaMetadata.METADATA_KEY_DISPLAY_TITLE, media.getDisplayName());
        builder.putString(MediaMetadata.METADATA_KEY_ARTIST, media.getMetadata().get(MediaStore.Audio.AudioColumns.ARTIST));
        builder.putString(MediaMetadata.METADATA_KEY_TITLE, media.getMetadata().get(MediaStore.MediaColumns.TITLE));
        builder.putString(MediaMetadata.METADATA_KEY_ALBUM_ARTIST, media.getMetadata().get(MediaStore.MediaColumns.ALBUM_ARTIST));
        builder.putString(MediaMetadata.METADATA_KEY_MEDIA_URI, media.getUri().toString());
        builder.putString(MediaMetadata.METADATA_KEY_DURATION, media.getMetadata().get(MediaStore.MediaColumns.DURATION));
        builder.putString(MediaMetadata.METADATA_KEY_ALBUM, media.getMetadata().get(MediaStore.Audio.AudioColumns.ALBUM));
        builder.putRating(MediaMetadata.METADATA_KEY_RATING, RatingCompat.fromRating(media.getRating()));
        builder.putBitmap(MediaMetadata.METADATA_KEY_ALBUM_ART, repo.getThumbBitmap(media));
//        MediaMetadataCompat data = builder.build();
//        if(data.getString(MediaMetadata.METADATA_KEY_TITLE) == null) builder.putString(MediaMetadata.METADATA_KEY_TITLE, curPlaying.getName());
//        if(data.getString(MediaMetadataCompat.METADATA_KEY_ARTIST) == null) builder.putString(MediaMetadata.METADATA_KEY_DISPLAY_TITLE, curPlaying.getParentFile().getName());
//        if(data.getString(MediaMetadata.METADATA_KEY_DISPLAY_TITLE) == null) builder.putString(MediaMetadata.METADATA_KEY_DISPLAY_TITLE, curPlaying.getName());
//        data = builder.build();
//        return data;

        return builder.build();
    }


    static void playlistAdd(Media[] medias) {
        for(Media media : medias) {
            if(media.type == Media.Type.AUDIO && !playlist.contains(media)) playlist.add(media);
        }
    }

    static void playlistRemove(Media[] mf) {
        for(Media f : mf) {
            playlist.remove(f);
        }
    }

    static boolean inPlaylist(Media f) {
        if(playlist == null) {
            playlist = new ArrayList<>();
            return false;
        }
        return playlist.contains(f);
    }

    void toNext() {
        pos = getPosition(curPlaying);
        ready = false;
//        MediaView.playerReady = false;
        player.reset();
        pos = pos == (playlist.size()-1) ? pos = 0 : pos+1;
        curPlaying = playlist.get(pos);
        try {
            player.setDataSource(applicationContext, curPlaying.getUri());
            player.prepare();
        } catch(Exception e) {
            //idk
        }
    }

    void toPrev() {
        pos = getPosition(curPlaying);
        ready = false;
//        MediaView.playerReady = false;
        player.reset();
        pos = pos > 0 ? pos-1 : playlist.size()-1;
        curPlaying = playlist.get(pos);
        try {
            player.setDataSource(applicationContext, curPlaying.getUri());
            player.prepare();
        } catch(Exception e) {
            //idk
        }
    }

    static void gotoSong(Media media) {
        if(playlist.contains(media)) {
//            int i;
//            for(i = 0; i < playlist.size(); i++) {
//                if(media.equals(playlist.get(i))) break;
//            }
            pos = playlist.indexOf(media);
            changeSong(media);
        }
    }

    private int getPosition(Media media) {
        pos = playlist.indexOf(media);
        if(player.isPlaying() && media.equals(player.isPlaying()))
//        int i;
//        for(i = 0; i < playlist.size(); i++) {
//            if(media.equals(playlist.get(i))) return i;
//        }
//        return -1;
    }

    static long getDur() {
        if(player != null && player.isPlaying()) {
            return player.getDuration();
        } else {
            return -1;
        }
    }

    static void changeSong(Media f) {
        ready = false;
//        MediaView.playerReady = false;
        curPlaying = f;
        player.reset();
        try {
            player.setDataSource(applicationContext, curPlaying.getUri());
            player.prepare();
        } catch(Exception e) {
            //idk
        }
    }

    /**
     * Create and set NotificationChannel
     */
    private void createChannel() {
        if(Build.VERSION.SDK_INT >= 26) {
            String name = "Super Media Bros.";
            String des = "Audio Player";
            int imp = NotificationManager.IMPORTANCE_LOW;
            NotificationChannel channel = new NotificationChannel(id, name, imp);
            channel.setDescription(des);
            getSystemService(NotificationManager.class).createNotificationChannel(channel);
        }
    }

    /**
     * Create and return notification to display when playing
     */
    private Notification buildPlayNote() {
        NotificationCompat.Builder build;
        build = new NotificationCompat.Builder(MusicPlayerService.this, id);
        build.setContentTitle(curPlaying.getDisplayName()).setSmallIcon(R.mipmap.ic_launcher_foreground).setContentIntent(touch).setDeleteIntent(MediaButtonReceiver.buildMediaButtonPendingIntent(this, PlaybackStateCompat.ACTION_STOP))
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .addAction(new NotificationCompat.Action(R.drawable.media_session_service_notification_ic_skip_to_previous, "previous", MediaButtonReceiver.buildMediaButtonPendingIntent(this, PlaybackStateCompat.ACTION_SKIP_TO_PREVIOUS)))
                .addAction(new NotificationCompat.Action(R.drawable.media_session_service_notification_ic_pause, "pause", MediaButtonReceiver.buildMediaButtonPendingIntent(this, PlaybackStateCompat.ACTION_PAUSE)))
                .addAction(new NotificationCompat.Action(R.drawable.media_session_service_notification_ic_skip_to_next, "next", MediaButtonReceiver.buildMediaButtonPendingIntent(this, PlaybackStateCompat.ACTION_SKIP_TO_NEXT)))
                .setStyle(new androidx.media.app.NotificationCompat.MediaStyle().setMediaSession(session.getSessionToken()).setShowActionsInCompactView(0,1,2).setShowCancelButton(true)
                        .setCancelButtonIntent(MediaButtonReceiver.buildMediaButtonPendingIntent(this, PlaybackStateCompat.ACTION_STOP)));
        return build.build();
    }

    /**
     * Create and return notification to display when paused
     */
    private Notification buildPauseNote() {
        NotificationCompat.Builder build;
        build = new NotificationCompat.Builder(MusicPlayerService.this, id);
        build.setContentTitle(curPlaying.getMetadata().get(MediaStore.MediaColumns.DISPLAY_NAME)).setSmallIcon(R.mipmap.ic_launcher_foreground).setVisibility(NotificationCompat.VISIBILITY_PUBLIC).setContentIntent(touch)
                .setDeleteIntent(MediaButtonReceiver.buildMediaButtonPendingIntent(this, PlaybackStateCompat.ACTION_STOP))
                .addAction(new NotificationCompat.Action(R.drawable.media_session_service_notification_ic_skip_to_previous, "previous", MediaButtonReceiver.buildMediaButtonPendingIntent(this, PlaybackStateCompat.ACTION_SKIP_TO_PREVIOUS)))
                .addAction(new NotificationCompat.Action(R.drawable.media_session_service_notification_ic_play, "play", MediaButtonReceiver.buildMediaButtonPendingIntent(this, PlaybackStateCompat.ACTION_PLAY)))
                .addAction(new NotificationCompat.Action(R.drawable.media_session_service_notification_ic_skip_to_next, "next", MediaButtonReceiver.buildMediaButtonPendingIntent(this, PlaybackStateCompat.ACTION_SKIP_TO_NEXT)))
                .setStyle(new androidx.media.app.NotificationCompat.MediaStyle().setMediaSession(session.getSessionToken()).setShowActionsInCompactView(0, 1, 2).setShowCancelButton(true)
                        .setCancelButtonIntent(MediaButtonReceiver.buildMediaButtonPendingIntent(this, PlaybackStateCompat.ACTION_STOP)));
        return build.build();
    }

    private AudioManager.OnAudioFocusChangeListener focusChangeListener = new AudioManager.OnAudioFocusChangeListener() {
        public void onAudioFocusChange(int focusChange) {
            AudioManager am = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
            switch (focusChange) {
                case (AudioManager.AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK):
                    session.getController().getTransportControls().pause();
                    break;
                case (AudioManager.AUDIOFOCUS_LOSS_TRANSIENT):
                    session.getController().getTransportControls().pause();
                    break;
                case (AudioManager.AUDIOFOCUS_LOSS):
                    Toast.makeText(getApplicationContext(), "Audio focus lost", Toast.LENGTH_LONG).show();
                    player.stop();
                    am.abandonAudioFocus(this);
                    break;
                case (AudioManager.AUDIOFOCUS_GAIN):
                    player.setVolume(1f, 1f);
                    session.getController().getTransportControls().play();
                    break;
                default:
                    break;
            }
        }
    };

    /**
     * Broadcast receiver to notify service the audio output has changed
     */
    private class OutputChange extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            if(AudioManager.ACTION_AUDIO_BECOMING_NOISY.equals(intent.getAction())) {
                session.getController().getTransportControls().pause();
            }
        }
    }
}
