package com.shayne.wec2017;

import android.app.DatePickerDialog;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.text.InputType;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Spinner;

import com.parse.ParseObject;
import com.parse.ParseUser;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

/**
 * Created by Shayne on 2016-06-21.
 */
public class EditProfileActivity extends AppCompatActivity implements View.OnClickListener {

    EditText etFullname;
    Spinner spSchool;
    Spinner spYear;
    EditText etTitle;
    EditText etEmail;
    EditText etGender;
    EditText etInfo;
    EditText etPhone;
    EditText etDate;
    EditText etDiscipline;
    Button btSave;

    private int year;
    private int month;
    private int day;
    static final int DATE_DIALOG_ID = 999;
    Date date;
    DateFormat df = new SimpleDateFormat("MM/dd/yyyy", Locale.CANADA);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_profile);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        findViewsById();
        populateEditTexts();

        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this,
                R.array.school_name_array, android.R.layout.simple_spinner_item);
        // Specify the layout to use when the list of choices appears
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        // Apply the adapter to the spinner
        spSchool.setAdapter(adapter);

        ArrayAdapter<CharSequence> yearAdapter = ArrayAdapter.createFromResource(this,
                R.array.year_array, android.R.layout.simple_spinner_item);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spYear.setAdapter(yearAdapter);

        btSave.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pushProfileToParse();
                finish();
            }
        });
        etDate.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        if (v == etDate) {
/*            // Get birthday if exists, if not, current day
            if (date != null) {
                year = date.getYear();
                month = date.getMonth();
                day = date.getDay();
            }
            else {*/
                final Calendar c = Calendar.getInstance();
                year = c.get(Calendar.YEAR);
                month = c.get(Calendar.MONTH);
                day = c.get(Calendar.DAY_OF_MONTH);
/*            }*/

            DatePickerDialog datePickerDialog = new DatePickerDialog(this,
                    new DatePickerDialog.OnDateSetListener() {
                        @Override
                        public void onDateSet(DatePicker view, int year,
                                              int monthOfYear, int dayOfMonth) {
                            etDate.setText(dayOfMonth + "-" + (monthOfYear + 1) + "-" + year);
                            date = new Date();
                            date.setYear(year - 1900);
                            date.setMonth(monthOfYear);
                            date.setDate(dayOfMonth - 1);
                        }
                    }, year, month, day);
            datePickerDialog.show();
        }
    }

    private void findViewsById() {
        etFullname = (EditText)findViewById(R.id.etFullName);
        etEmail = (EditText)findViewById(R.id.etEmail);
        spSchool = (Spinner)findViewById(R.id.spSchoolName);
        spYear = (Spinner)findViewById(R.id.spYear);
        etTitle = (EditText)findViewById(R.id.etTitle);
        etGender = (EditText)findViewById(R.id.etGender);
        etInfo = (EditText)findViewById(R.id.etInfo);
        etPhone = (EditText)findViewById(R.id.etPhone);
        etDate = (EditText)findViewById(R.id.etDate);
        etDiscipline = (EditText)findViewById(R.id.etDiscipline);
        btSave = (Button)findViewById(R.id.btSaveProfile);

        etDate.setInputType(InputType.TYPE_NULL);
    }

    private void populateEditTexts() {
        ParseUser user = ParseUser.getCurrentUser();
        if (user != null) {
            if (user.get("fullname") != null) {
                etFullname.setText(user.get("fullname").toString());
            }
            if (user.getEmail() != null) {
                etEmail.setText(user.getEmail());
            }
            if (user.get("title") != null) {
                etTitle.setText(user.get("title").toString());
            }
            if (user.get("gender") != null) {
                etGender.setText(user.get("gender").toString());
            }
            if (user.get("info") != null) {
                etInfo.setText(user.get("info").toString());
            }
            if (user.get("phone") != null) {
                etPhone.setText(user.get("phone").toString());
            }
            if (user.get("birthday") != null) {
                etDate.setText(df.format(user.get("birthday")));
                date = (Date)user.get("birthday");
            }
            else {
                date = null;
            }
            if (user.get("option") != null) {
                etDiscipline.setText(user.get("option").toString());
            }
        }
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
        String year = spYear.getSelectedItem().toString();
        String discipline = etDiscipline.getText().toString();
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
        if (date != null) {
            user.put("birthday", date);
        }
        if (!year.equals("")) {
            user.put("year", year);
        }
        if (!discipline.equals("")) {
            user.put("option", discipline);
        }

        user.saveInBackground();
    }
}
