package com.example.native_interaction_app_flutter;

import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.PersistableBundle;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.nio.ByteBuffer;

import javax.xml.transform.Result;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterView;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    Context mContext;
    BasicMessageChannel<Object> _basicMessageChannel;
    int count = 0;

    private static final String BASIC_MESSAGE_CHANNEL = "flutter_demo_jiaohu.flutter.io/basic_message_channel";
    private static final String METHOD_CHANNEL = "flutter_demo_jiaohu.flutter.io/method_channel";
    private static final String EVENT_CHANNEL = "flutter_demo_jiaohu.flutter.io/event_channel";
    BinaryMessenger binaryMessenger;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(getFlutterEngine());
         binaryMessenger = getFlutterEngine().getDartExecutor().getBinaryMessenger();
        _basicMessageChannel = new BasicMessageChannel<Object>(binaryMessenger, BASIC_MESSAGE_CHANNEL, StandardMessageCodec.INSTANCE);
        // 接收消息监听
        _basicMessageChannel.setMessageHandler(new BasicMessageChannel.MessageHandler<Object>() {
            @Override
            public void onMessage(Object o, BasicMessageChannel.Reply<Object> reply) {
                System.out.println("activity-onMessage--flutter传来得数据: " + o);
                reply.reply("已开启免打扰模式" + (count++));
            }
        });

        new MethodChannel(binaryMessenger, METHOD_CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                if (call.method.equals("getBatteryLevel")){
                        int batteryLevel = getBatteryLevel();
                    if (batteryLevel != -1) {
                        result.success(batteryLevel);
                    } else {
                        result.error("UNAVAILABLE", "Battery level not available.", null);
                    }
                }else{
                    result.notImplemented();
                }
            }
        });

        new EventChannel(binaryMessenger, EVENT_CHANNEL).setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object o, EventChannel.EventSink eventSink) {
                        this.eventSink = eventSink;
                        handler.sendEmptyMessageDelayed(1, 1000);
                    }

                    @Override
                    public void onCancel(Object o) {
                    }

                    private EventChannel.EventSink eventSink;
                    private Handler handler = new Handler() {
                        @Override
                        public void handleMessage(Message msg) {
                            super.handleMessage(msg);
                            eventSink.success("主动发送消息给flutter"  + (count++));
                            // handler.sendEmptyMessageDelayed(1,1000);
                        }
                    };
                }
        );
    }


    private int getBatteryLevel() {
        int batteryLevel = -1;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        } else {
            Intent intent = new ContextWrapper(getApplicationContext()).
                    registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }

        BasicMessageChannel<Object> messageChannel2 = new BasicMessageChannel<Object>(binaryMessenger, "samples.flutter.io/message2", StandardMessageCodec.INSTANCE);

        // 发送消息
        messageChannel2.send("发送给flutter的数据", new BasicMessageChannel.Reply<Object>() {
            @Override
            public void reply(Object o) {
                System.out.println("activity-onReply: " + o);
            }
        });
        return batteryLevel;
    }
}
