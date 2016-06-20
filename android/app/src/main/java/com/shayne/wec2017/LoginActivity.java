package com.shayne.wec2017;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.parse.LogInCallback;
import com.parse.ParseException;
import com.parse.ParseUser;
import com.parse.SignUpCallback;

public class LoginActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        final EditText etUsername = (EditText)findViewById(R.id.etUsername);
        final EditText etPassword = (EditText)findViewById(R.id.etPassword);
        Button btLogin = (Button)findViewById(R.id.btLogin);
        Button btSignup = (Button)findViewById(R.id.btSignup);

        // Login button listener
        btLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String username = etUsername.getText().toString();
                String password = etPassword.getText().toString();

                ParseUser.logInInBackground(username, password, new LogInCallback() {
                    @Override
                    public void done(ParseUser user, ParseException e) {
                        if (user != null) {
                            // User exists, go to ChatActivity
                            // TODO: go to proper activity (welcome screen?)
                            Intent intent = new Intent(LoginActivity.this, MainActivity.class);
                            startActivity(intent);
                            Toast.makeText(getApplicationContext(), "Log in successful",
                                    Toast.LENGTH_LONG).show();
                            finish();
                        }
                        else {
                            Toast.makeText(getApplicationContext(), "Incorrect username or password",
                                    Toast.LENGTH_LONG).show();
                        }
                    }
                });
            }
        });

        // Signup button listener
        btSignup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final String username = etUsername.getText().toString();
                final String password = etPassword.getText().toString();

                ParseUser user = new ParseUser();
                user.setUsername(username);
                user.setPassword(password);
                user.signUpInBackground(new SignUpCallback() {
                    @Override
                    public void done(ParseException e) {
                        if (e == null) {
                            // Registration successful, log the user in
                            Toast.makeText(getApplicationContext(), "User account created",
                                    Toast.LENGTH_LONG).show();
                            ParseUser.logInInBackground(username, password, new LogInCallback() {
                                @Override
                                public void done(ParseUser user, ParseException e) {
                                    if (user != null) {
                                        // User exists, go to ChatActivity
                                        // TODO: go to proper activity (welcome screen?)
                                        Intent intent = new Intent(LoginActivity.this, MainActivity.class);
                                        startActivity(intent);
                                        Toast.makeText(getApplicationContext(), "Log in successful",
                                                Toast.LENGTH_LONG).show();
                                        finish();
                                    }
                                    else {
                                        Toast.makeText(getApplicationContext(), "Login failed",
                                                Toast.LENGTH_LONG).show();
                                    }
                                }
                            });
                        }
                    }
                });
            }
        });
    }
}
