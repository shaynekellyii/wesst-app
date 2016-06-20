package com.shayne.wec2017;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import com.parse.FindCallback;
import com.parse.LogInCallback;
import com.parse.ParseAnonymousUtils;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseUser;
import com.parse.SaveCallback;

import java.util.ArrayList;
import java.util.List;

public class InitActivity extends AppCompatActivity {
    static final String TAG = InitActivity.class.getSimpleName();
    static final String USER_ID_KEY = "userId";
    static final String BODY_KEY = "body";
    static final int MAX_CHAT_MESSAGES_TO_SHOW = 50;
    static final int POLL_INTERVAL = 100; // milliseconds

    EditText etMessage;
    Button btSend;
    ListView lvChat;
    ArrayList<Message> mMessages;
    // Keep track of initial load to scroll to the bottom of the ListView
    boolean mFirstLoad;

    Handler mHandler = new Handler(); // android.os.handler
    Runnable mRefreshMessagesRunnable = new Runnable() {
        @Override
        public void run() {
            refreshMessages();
            mHandler.postDelayed(this, POLL_INTERVAL);
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chat);

        // User login
        if (ParseUser.getCurrentUser() != null && !ParseAnonymousUtils.isLinked(ParseUser.getCurrentUser())) {
            // Start with existing user
            //startWithCurrentUser();
            Intent intent = new Intent(InitActivity.this, MainActivity.class);
            startActivity(intent);
            finish();
        }
        else { // TODO: If not logged in, go to login activity
            // Old method:
            // login();

            // New method, go to login activity:
            Intent intent = new Intent(InitActivity.this, LoginActivity.class);
            startActivity(intent);
            finish();
        }

        //mHandler.postDelayed(mRefreshMessagesRunnable, POLL_INTERVAL);
    }

    // Get the userId from the cached currentUser object
    /*void startWithCurrentUser() {
        setupMessagePosting();
    }*/

    // Setup button event handler which posts the entered message to Parse
    /*void setupMessagePosting() {
        // Find the text field and button
        etMessage = (EditText)findViewById(R.id.etMessage);
        btSend = (Button)findViewById(R.id.btSend);
        lvChat = (ListView)findViewById(R.id.lvChat);
        mMessages = new ArrayList<>();

        // Automatically scroll to the bottom when a data set change notification is received
        lvChat.setTranscriptMode(1);
        mFirstLoad = true;
        final String userId = ParseUser.getCurrentUser().getObjectId();
        mAdapter = new ChatListAdapter(InitActivity.this, userId, mMessages);
        lvChat.setAdapter(mAdapter);

        // When send button is clicked, create message object on Parse
        btSend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String data = etMessage.getText().toString();
                ParseObject message = ParseObject.create("Message");
                message.put(Message.USER_ID_KEY, ParseUser.getCurrentUser().getObjectId());
                message.put(Message.BODY_KEY, data);
                message.saveInBackground(new SaveCallback() {
                                             @Override
                                             public void done(ParseException e) {
                                                 Toast.makeText(InitActivity.this, "Successfully " +
                                                         "created message on Parse",
                                                         Toast.LENGTH_SHORT).show();
                                             }
                                         });
            }
        });
        etMessage.setText(null);
    }*/

    // Query messages from Parse so we can load them into the chat adapter
    void refreshMessages() {
        // Construct query to execute
        ParseQuery<Message> query = ParseQuery.getQuery(Message.class);

        // Configure limit and sort order
        query.setLimit(MAX_CHAT_MESSAGES_TO_SHOW);
        query.orderByAscending("createdAt");

        // Execute query to fetch all messages from Parse asynchronously
        // This is equivalent to a SELECT query with SQL
        query.findInBackground(new FindCallback<Message>() {
            @Override
            public void done(List<Message> messages, ParseException e) {
                if (e == null) {
                    mMessages.clear();
                    mMessages.addAll(messages);
                    //mAdapter.notifyDataSetChanged(); // update adapter
                    // Scroll to the bottom of the list on initial load
                    if (mFirstLoad) {
                        //lvChat.setSelection(mAdapter.getCount() - 1);
                        mFirstLoad = false;
                    }
                }
                else {
                    Log.e("message", "Error loading messages" + e);
                }
            }
        });
    }

    // Create an anonymous user using ParseAnonymousUtils and set sUserId
    void login() {
        ParseAnonymousUtils.logIn(new LogInCallback() {
            @Override
            public void done(ParseUser user, ParseException e) {
                if (e != null) {
                    Log.e(TAG, "Anonymous login failed: ", e);
                }
                else {
                    //startWithCurrentUser();
                }
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_chat, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
