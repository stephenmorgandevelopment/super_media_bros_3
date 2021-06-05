package com.stephenmorgandevelopment.super_media_bros_3.flutter;

import android.net.Uri;

import com.stephenmorgandevelopment.super_media_bros_3.models.Audio;
import com.stephenmorgandevelopment.super_media_bros_3.models.Image;
import com.stephenmorgandevelopment.super_media_bros_3.models.Media;
import com.stephenmorgandevelopment.super_media_bros_3.models.Video;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.LinkedHashMap;
import java.util.Map;

import io.flutter.plugin.common.StandardMessageCodec;

public class FlutterMediaMessageCodec extends StandardMessageCodec {
	public static final FlutterMediaMessageCodec INSTANCE = new FlutterMediaMessageCodec();
	
	public FlutterMediaMessageCodec() {
	
	}
	
	private static final byte DATA_TYPE_MEDIA = (byte) 163;
	private static final byte DATA_TYPE_URI = (byte) 164;
	
	private static final byte DATA_TYPE_TYPE = (byte) 166;
	private static final byte DATA_TYPE_IMAGE = (byte) 200;
	private static final byte DATA_TYPE_VIDEO = (byte) 201;
	private static final byte DATA_TYPE_AUDIO = (byte) 202;
	
	@Override
	protected void writeValue(ByteArrayOutputStream stream, Object value) {
		if (value instanceof Media) {	// || value instanceof Image || value instanceof Video || value instanceof Audio) {
			stream.write(DATA_TYPE_MEDIA);
			
			Media media = ((Media) value);
			writeValue(stream, String.valueOf(media.getUri()));
			writeValue(stream, media.getType());
			writeValue(stream, media.getMetadata());
		} else if (value instanceof Media.Type) {
			switch ((Media.Type) value) {
				case IMAGE:
					stream.write(DATA_TYPE_TYPE);
					stream.write(DATA_TYPE_IMAGE);
					break;
				case VIDEO:
					stream.write(DATA_TYPE_TYPE);
					stream.write(DATA_TYPE_VIDEO);
					break;
				case AUDIO:
					stream.write(DATA_TYPE_TYPE);
					stream.write(DATA_TYPE_AUDIO);
					break;
			}
		} else if (value instanceof Uri) {	// Left here in case I want to send Uri's later.
			stream.write(DATA_TYPE_URI);
			super.writeValue(stream, ((Uri)value).toString());
		} else {
			super.writeValue(stream, value);
		}
	}
	
	@Override
	@SuppressWarnings("unchecked")
	protected Object readValueOfType(byte type, ByteBuffer buffer) {
		switch (type) {
			case DATA_TYPE_MEDIA:
				Uri uri = Uri.parse((String) readValue(buffer));
				Media.Type _type = (Media.Type) readValue(buffer);
				Map<Object, Object> map = (Map<Object, Object>) readValue(buffer);
				
				Map<String, String> metadata = new LinkedHashMap<>();
				for(Map.Entry<Object, Object> entry : map.entrySet()) {
					metadata.put(entry.getKey().toString(), entry.getValue().toString());
				}
				
				return makeMedia(uri, _type, metadata);
			case DATA_TYPE_TYPE:
				switch (buffer.get()) {
					case DATA_TYPE_IMAGE:
						return Media.Type.IMAGE;
					case DATA_TYPE_VIDEO:
						return Media.Type.VIDEO;
					case DATA_TYPE_AUDIO:
						return Media.Type.AUDIO;
					default:
						return null;
				}
			case DATA_TYPE_URI:
				return Uri.parse((String) readValue(buffer));
			default:
				return super.readValueOfType(type, buffer);
		}
	}
	
	private Media makeMedia(Uri uri, Media.Type type, Map<String, String> metadata) {
		switch(type) {
			case IMAGE:
				return new Image(uri, metadata);
			case VIDEO:
				return new Video(uri, metadata);
			case AUDIO:
				return new Audio(uri, metadata);
		}
		return null;
	}
}
