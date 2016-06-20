package com.shayne.wec2017;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.ListFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseUser;
import com.parse.SaveCallback;

import java.util.ArrayList;

public class StreamFragment extends ListFragment {

    ArrayList<Post> mPostList;
    ListView lvStream;
    boolean mFirstLoad;
    PostListAdapter mAdapter;

    /*@Override
    public void onCreate(Bundle savedInstanceState) {
        setupStreamPosting();
    }*/

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView;
        rootView = inflater.inflate(R.layout.fragment_stream, container, false);
        lvStream = (ListView)rootView.findViewById(android.R.id.list);
        return rootView;
    }

    public void onActivityCreated() {
        setupStreamPosting();
    }

    // Setup button event handler which posts the entered message to Parse
    void setupStreamPosting() {
        // Find the text field and button
        // lvStream = (ListView)getView().findViewById(R.id.lvStream); // Caused null pointer exception

        mPostList = new ArrayList<>();

        // Automatically scroll to the bottom when a data set change notification is received
        lvStream.setTranscriptMode(1);
        mFirstLoad = true;
        final String userId = ParseUser.getCurrentUser().getObjectId();
        StreamFragment.this.setListAdapter(mAdapter);
        lvStream.setAdapter(mAdapter);

        // When send button is clicked, create message object on Parse
        /*btSend.setOnClickListener(new View.OnClickListener() {
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
        });*/
        /*etMessage.setText(null);*/
    }
}