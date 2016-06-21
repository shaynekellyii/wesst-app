package com.shayne.wec2017;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;

import com.parse.ParseUser;

/**
 * Created by Shayne on 2016-06-21.
 */
public class EditProfileActivity extends AppCompatActivity {

    EditText etFullname;
    Spinner spSchool;
    EditText etTitle;
    EditText etEmail;
    EditText etGender;
    EditText etInfo;
    EditText etPhone;
    EditText etDate;
    Button btSave;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_profile);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        findViewsById();

        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this,
                R.array.school_name_array, android.R.layout.simple_spinner_item);
        // Specify the layout to use when the list of choices appears
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        // Apply the adapter to the spinner
        spSchool.setAdapter(adapter);

        btSave.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pushProfileToParse();
                finish();
            }
        });
    }

    private void findViewsById() {
        etFullname = (EditText)findViewById(R.id.etFullName);
        etEmail = (EditText)findViewById(R.id.etEmail);
        spSchool = (Spinner)findViewById(R.id.spSchoolName);
        etTitle = (EditText)findViewById(R.id.etTitle);
        etGender = (EditText)findViewById(R.id.etGender);
        etInfo = (EditText)findViewById(R.id.etInfo);
        etPhone = (EditText)findViewById(R.id.etPhone);
        etDate = (EditText)findViewById(R.id.etDate);
        btSave = (Button)findViewById(R.id.btSaveProfile);
    }

    private void pushProfileToParse() {
        ParseUser user = ParseUser.getCurrentUser();
        String fullname = etFullname.getText().toString();
        String school = spSchool.getSelectedItem().toString();
        String title = etTitle.getText().toString();
        String email = etEmail.getText().toString();
        String gender = etGender.getText().toString();
        String info = etInfo.getText().toString();
        String phone = etPhone.getText().toString();
        //String date = etEmail.getText().toString();

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
        if (!gender.equals("")) {
            user.put("gender", gender);
        }
        if (!info.equals("")) {
            user.put("info", info);
        }
        if (!phone.equals("")) {
            user.put("phone", phone);
        }

        user.saveInBackground();
    }
}
