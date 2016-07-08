package com.shayne.wec2017;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.parse.FindCallback;
import com.parse.GetDataCallback;
import com.parse.ParseException;
import com.parse.ParseFile;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseUser;
import com.parse.SaveCallback;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * Created by Shayne on 2016-06-22.
 */
public class PostDetailActivity extends AppCompatActivity {
    ListView listView;
    DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss", Locale.CANADA);
    TextView tvPostAuthorDate;
    TextView tvPostContent;
    List<Comment> comments;
    Comment comment;
    PostDetailAdapter adapter;
    Button btComment;
    EditText etComment;
    Posts post;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // Inflate layout
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_post_detail);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        // Setup comment listview and adapter
        comments = new ArrayList<>();
        listView = (ListView)findViewById(android.R.id.list);
        adapter = new PostDetailAdapter(this, R.layout.post_list_item, comments);
        listView.setAdapter(adapter);

        // Get post id and populate post view
        Intent intent = getIntent();
        String id = intent.getStringExtra("id");
        tvPostAuthorDate = (TextView)findViewById(R.id.tvPostAuthorDate);
        tvPostContent = (TextView)findViewById(R.id.tvPostContent);
        assert tvPostAuthorDate != null;
        tvPostAuthorDate.setText("Loading...");
        fetchPost(id);

        // Set listener to post comment
        btComment = (Button)findViewById(R.id.btComment);
        btComment.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {
                sendComment();
            }
        });
    }

    private void sendComment() {
        etComment = (EditText)findViewById(R.id.etComment);
        ParseUser user = ParseUser.getCurrentUser();
        if (post != null && !etComment.getText().toString().matches("")) {
            post.add("comments", etComment.getText().toString());
            post.add("commentsDate", new Date());
            post.add("commentsUser", user);
            post.increment("replies");

            post.saveInBackground(new SaveCallback() {
                @Override
                public void done(ParseException e) {
                    if (e == null) {
                        Snackbar.make(findViewById(R.id.post_detail_activity), "Comment sent", Snackbar.LENGTH_SHORT).show();
                    } else {
                        Log.e("Comment didn't save", e.toString());
                    }
                }
            });
        }
        else {
            Snackbar.make(findViewById(R.id.post_detail_activity), "Please add content to your comment", Snackbar.LENGTH_SHORT).show();
        }
    }

    private void fetchPost(String id) {
        ParseQuery<Posts> query = ParseQuery.getQuery("Posts");
        query.whereEqualTo("objectId", id);
        query.findInBackground(new FindCallback<Posts>() {
            @Override
            public void done(List<Posts> objects, ParseException e) {
                if (e == null) {
                    post = objects.get(0);
                    getPostAuthor(post);
                    try {
                        packageComments(post);
                    }
                    catch (Exception jsonException) {
                        // oops
                    }
                } else {
                    // error
                }
            }
        });
    }

    private void getPostAuthor(final Posts post) {
        ParseUser user = post.getParseUser("user");
        try {
            user.fetch();
        }
        catch (ParseException e) {
            // oops
        }

        if (user.get("fullname") != null) {
            fillPost(post, user.get("fullname").toString());
        }
        else {
            fillPost(post, user.get("username").toString());
        }
        if ((Boolean)post.get("hasImage")) {
            fillImage(post);
        }
    }

    private void fillPost(Posts post, String author) {
        String authorAndDate = author + ", " + df.format(post.getCreatedAt());

        assert tvPostAuthorDate != null;
        tvPostAuthorDate.setText(authorAndDate);
        assert tvPostContent != null;
        tvPostContent.setText(post.get("info").toString());
    }

    private void fillImage(Posts post) {
        ParseFile imageFile = (ParseFile)post.get("image");
        imageFile.getDataInBackground(new GetDataCallback() {
            @Override
            public void done(byte[] data, ParseException e) {
                if (e == null) {
                    Bitmap bmp = BitmapFactory.decodeByteArray(data, 0, data.length);
                    ImageView imageView = (ImageView)findViewById(R.id.ivPostDetail);
                    assert imageView != null;
                    imageView.setImageBitmap(bmp);
                    //imageView.setPadding(0,0,0,bmp.getHeight() + 15);
                }
                else {
                    Log.e("PostDetailActivity", "Problem loading image from Parse");
                }
            }
        });
    }

    private void packageComments(Posts post) throws JSONException {
        List<String> contentList = post.getList("comments");
        List<Date> contentDate = post.getList("commentsDate");
        JSONArray commentAuthor = post.getJSONArray("commentsUser");

        if (contentList != null) {
            for (int i = 0; i < contentList.size(); i++) {
                JSONObject jsonAuthor = commentAuthor.getJSONObject(i);
                String author = jsonAuthor.getString("objectId");
                Comment comment = new Comment();
                comment.setContent(contentList.get(i));
                comment.setDate(contentDate.get(i));
                comment.setAuthor(author);
                comments.add(comment);
            }
        }

        if (comments.size() > 0 && adapter != null) {
            adapter.notifyDataSetChanged();
        }
    }
}
