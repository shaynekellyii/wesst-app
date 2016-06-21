package com.shayne.wec2017;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.parse.ParseUser;

/**
 * Created by Shayne on 2016-06-21.
 */
public class EditProfileActivity extends AppCompatActivity {

    EditText etFullname;
    EditText etSchool;
    EditText etTitle;
    EditText etEmail;
    Button btSave;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_profile);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        etFullname = (EditText)findViewById(R.id.etFullName);
        etEmail = (EditText)findViewById(R.id.etEmail);
        etSchool = (EditText)findViewById(R.id.etSchoolName);
        etTitle = (EditText)findViewById(R.id.etTitle);

        btSave = (Button)findViewById(R.id.btSaveProfile);
        btSave.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pushProfileToParse();
                finish();
            }
        });
    }

    private void pushProfileToParse() {
        ParseUser user = ParseUser.getCurrentUser();
        String fullname = etFullname.getText().toString();
        String school = etSchool.getText().toString();
        String title = etTitle.getText().toString();
        String email = etEmail.getText().toString();

        if (!fullname.equals("")) {
            user.put("fullname", fullname);
        }
        if (!school.equals("")) {
            user.put("school", school);
        }
        if (!title.equals("")) {
            user.put("title", title);
        }
        if (!email.equals("")) {
            user.setEmail(email);
        }

        user.saveInBackground();
    }
}
