package com.example.app_block_rit;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import androidx.core.app.NotificationCompat;
import java.util.Calendar;


public class AppService extends Service {
    public static final String CHANNEL_ID = "ForegroundServiceChannel";

    public AppService() {
    }

    public int onStartCommand (Intent intent, int flags, int startId) {
        createNotificationChannel();
        Notification notification = new NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("App Time")
                .setContentText("App Running!")
                .setSmallIcon(R.drawable.logo)
                .build();

        startForeground(1, notification);

        AllStatic.appServiceContext=this;
        AllStatic.timeSlotsEnd=false;

        Thread x=new Thread(new Runnable() {
            @Override
            public void run() {
                while(AllStatic.appThread ==true){

                    Calendar rightNow = Calendar.getInstance();

                    if (rightNow.get(Calendar.HOUR_OF_DAY)==10 && rightNow.get(Calendar.MINUTE)==8 & rightNow.get(Calendar.SECOND)==0){
                        for(int i = 0; i < AllStatic.profiles.size(); i++){
                            if (AllStatic.profiles.get(i).get(0).indexOf(Integer.toString(rightNow.get(Calendar.DAY_OF_WEEK)))!=-1){
                                System.out.println("Profile "+i);
                                AllStatic.startTime= AllStatic.profiles.get(i).get(1);
                                AllStatic.endTime= AllStatic.profiles.get(i).get(2);
                                AllStatic.app_names= AllStatic.profiles.get(i).get(3);
                                System.out.println(AllStatic.app_names);
                                break;
                            }
                        }
                    }

                    if (AllStatic.startTime!=null && AllStatic.endTime!=null){
                        if (rightNow.get(Calendar.HOUR_OF_DAY) >= (Integer.parseInt(AllStatic.startTime.get(AllStatic.index).substring(0,2))) && rightNow.get(Calendar.MINUTE) >=(Integer.parseInt(AllStatic.startTime.get(AllStatic.index).substring(3,5))) && AllStatic.itsTime==false){
                            System.out.println("its time");
                            AllStatic.itsTime=true;
                            AllStatic.blockTimeStart=AllStatic.startTime.get(AllStatic.index);
                            AllStatic.blockTimeEnd=AllStatic.endTime.get(AllStatic.index);
                            AllStatic.startBlockService();
                        }

                        if (rightNow.get(Calendar.HOUR_OF_DAY)>=(Integer.parseInt(AllStatic.endTime.get(AllStatic.index).substring(0,2))) && rightNow.get(Calendar.MINUTE) >=(Integer.parseInt(AllStatic.endTime.get(AllStatic.index).substring(3,5))) && AllStatic.itsTime==true && AllStatic.timeSlotsEnd==false){
                            System.out.println("end time");
                            if (AllStatic.index< AllStatic.startTime.size()-1){
                                AllStatic.index+=1;
                                AllStatic.itsTime=false;
                            }
                            else{
                                System.out.println("No Times Slots Remaining");
                                AllStatic.timeSlotsEnd=true;
                            }
                            AllStatic.stopBlockService();
                        }
                    }

                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        });
        x.start();

        return START_NOT_STICKY;
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel serviceChannel = new NotificationChannel(
                    CHANNEL_ID,
                    "Foreground Service Channel",
                    NotificationManager.IMPORTANCE_DEFAULT
            );
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(serviceChannel);
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        // TODO: Return the communication channel to the service.
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public void onDestroy() {
        if (AllStatic.block_service_intent != null) {
            AllStatic.appServiceContext.stopService(AllStatic.block_service_intent);
            AllStatic.block_service_intent = null;
            System.out.println("Stopped Block Service");
        }

        AllStatic.appThread =false;
        AllStatic.itsTime=false;
        AllStatic.cancelTimer();

        stopForeground(true);
        super.onDestroy();
    }
}
