package com.example.app_block_rit;

import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;

public class BlockMsg extends AppCompatActivity {
    TextView timeText;
    TextView rewardTime;
    TextView bonusTimeText;
    TextView textView;
    Button close;
    Activity activity;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_blockmsg);
        timeText =(TextView) findViewById(R.id.timetext);
        rewardTime = (TextView) findViewById(R.id.rewardtime);
        close = (Button) findViewById(R.id.closebutton);
        textView= (TextView) findViewById(R.id.textView);
        bonusTimeText = (TextView) findViewById(R.id.bonustimetext);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            Window w = getWindow();
            w.setFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS, WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);
        }

        this.activity=this;

        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        timeText.setText(AllStatic.textTime);
        rewardTime.setText(AllStatic.textTimeReward);
        textView.setText(AllStatic.Description);
        bonusTimeText.setText(AllStatic.blockScreenLabel);


        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                activity.finish();
            }
        });
    }
}