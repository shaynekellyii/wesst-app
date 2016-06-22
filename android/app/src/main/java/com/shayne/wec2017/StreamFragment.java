package com.shayne.wec2017;


import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;

import com.parse.FindCallback;
import com.parse.Parse;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Shayne on 2016-06-21.
 */
public class StreamFragment extends android.support.v4.app.ListFragment {
    List<Posts> posts;
    PostListAdapter adapter;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        posts = new ArrayList<Posts>();
        getPosts();

        adapter = new PostListAdapter(inflater.getContext(), R.layout.post_list_item, posts);
        setListAdapter(adapter);

        return super.onCreateView(inflater, container, savedInstanceState);
    }

    private void getPosts() {
        ParseQuery<ParseObject> query = new ParseQuery<ParseObject>("Posts");
        query.findInBackground(new FindCallback<ParseObject>() {
            @Override
            public void done(List<ParseObject> objects, ParseException e) {
                for (ParseObject postObject : objects) {
                    posts.add((Posts)postObject);
                }
                if (posts.size() > 0 && adapter != null) {
                    adapter.notifyDataSetChanged();
                }
            }
        });
    }
}
