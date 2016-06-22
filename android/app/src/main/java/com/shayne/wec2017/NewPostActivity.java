package com.shayne.wec2017;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseUser;
import com.parse.SaveCallback;

public class NewPostActivity extends AppCompatActivity {

    Button btSend;
    EditText etPost;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_post);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        btSend = (Button)findViewById(R.id.btSendPost);
        etPost = (EditText)findViewById(R.id.etPost);
        btSend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {
                String data = etPost.getText().toString();
                ParseUser user = ParseUser.getCurrentUser();
                ParseObject post = ParseObject.create("Posts");

                if (data != "") {
                    post.put("info", data);
                }
                post.put("user", ParseObject.createWithoutData(ParseUser.class, user.getObjectId()));
                post.put("hasImage", false);

                post.saveInBackground(new SaveCallback() {
                    @Override
                    public void done(ParseException e) {
                        Snackbar.make(v, "Post successfully created", Snackbar.LENGTH_LONG)
                                .setAction("Action", null).show();
                    }
                });
            }
        });
        //finish();
    }

}
