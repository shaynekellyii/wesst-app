package com.shayne.wec2017;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;

import com.parse.ParseException;
import com.parse.ParseFile;
import com.parse.ParseObject;
import com.parse.ParseUser;
import com.parse.SaveCallback;

import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class NewPostActivity extends AppCompatActivity {

    Button btSend;
    Button btImg;
    EditText etPost;

    ParseObject post;
    Bitmap bitmap;
    ImageView imageView;

    private static final int SELECT_PHOTO_REQ_CODE = 100;
    private static final int REQUEST_CODE_ASK_PERMISSIONS = 123;
    private static final int MAX_IMG_DIM = 600;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_post);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        btSend = (Button)findViewById(R.id.btSendPost);
        etPost = (EditText)findViewById(R.id.etPost);
        btImg = (Button)findViewById(R.id.btAddImg);
        imageView = (ImageView)findViewById(R.id.ivImgPreview);

        post = ParseObject.create("Posts");
        post.put("hasImage", false);

        btImg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int hasPermission = ContextCompat.checkSelfPermission(NewPostActivity.this,
                        Manifest.permission.READ_EXTERNAL_STORAGE);
                if (hasPermission != PackageManager.PERMISSION_GRANTED) {
                    ActivityCompat.requestPermissions(NewPostActivity.this,
                    new String[]{Manifest.permission.READ_EXTERNAL_STORAGE},
                            REQUEST_CODE_ASK_PERMISSIONS);
                    return;
                }
                Intent intent = new Intent();
                intent.setType("image/*");
                intent.setAction(Intent.ACTION_GET_CONTENT);
                intent.addCategory(Intent.CATEGORY_OPENABLE);
                startActivityForResult(intent, SELECT_PHOTO_REQ_CODE);
            }
        });

        btSend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View v) {
                String data = etPost.getText().toString();
                ParseUser user = ParseUser.getCurrentUser();

                if (!data.matches("")) {
                    List<String> emptyStrList = new ArrayList<String>();
                    List<Date> emptyDateList = new ArrayList<Date>();

                    post.put("info", data);
                    post.put("user", ParseObject.createWithoutData(ParseUser.class, user.getObjectId()));
                    post.put("commentsDate", emptyDateList);
                    post.put("replies", 0);
                    post.put("commentsUsers", emptyStrList); // Which one to use?
                    post.put("comments", emptyStrList);
                    post.put("commentsUser", emptyStrList); // Which one to use?

                    post.saveInBackground(new SaveCallback() {
                        @Override
                        public void done(ParseException e) {
                            Snackbar.make(v, "Post successfully created", Snackbar.LENGTH_LONG)
                                    .setAction("Action", null).show();
                        }
                    });
                    finish();
                }
                else {
                    Snackbar.make(v, "Please add content to your post", Snackbar.LENGTH_LONG).show();
                }
            }
        });
    }

    private void packImageForParse() {
        int resizeCoeff = 1;

        assert bitmap != null;
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();

        // Resize image to match Parse limitations
        if (width > MAX_IMG_DIM || height > MAX_IMG_DIM) {
            if (width > height) {
                resizeCoeff = width / MAX_IMG_DIM;
            }
            else {
                resizeCoeff = height / MAX_IMG_DIM;
            }
            width /= resizeCoeff;
            height /= resizeCoeff;
            bitmap = Bitmap.createScaledBitmap(bitmap, width, height, false);
        }

        // Convert to jpg (required format for our ParseFile)
        try {
            ByteArrayOutputStream outStream = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, outStream);
            byte[] imgData = outStream.toByteArray();
            outStream.flush();
            outStream.close();

            // Add image to post
            ParseFile imgFile = new ParseFile("image.jpg", imgData);
            post.put("image", imgFile);
            post.put("hasImage", true);
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == SELECT_PHOTO_REQ_CODE && resultCode == Activity.RESULT_OK) {
            try {
                if (bitmap != null) {
                    bitmap.recycle();
                }
                InputStream stream = getContentResolver().openInputStream(data.getData());
                bitmap = BitmapFactory.decodeStream(stream);
                stream.close();

                imageView.setImageBitmap(bitmap);
                packImageForParse();

            }
            catch (FileNotFoundException e) {
                e.printStackTrace();
            }
            catch (IOException e) {
                e.printStackTrace();
            }
        }

        super.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           String permissions[], int[] grantResults) {
        switch (requestCode) {
            case REQUEST_CODE_ASK_PERMISSIONS: {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    Intent photoPickerIntent = new Intent(Intent.ACTION_PICK,
                            MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                    photoPickerIntent.setType("image/*");
                    startActivityForResult(photoPickerIntent, SELECT_PHOTO_REQ_CODE);

                }
                else {
                    Snackbar.make(findViewById(R.id.new_post_content), "Please grant permission to " +
                                    "file system to add a photo",
                            Snackbar.LENGTH_LONG).show();
                }
                return;
            }

            // other 'case' lines to check for other
            // permissions this app might request
        }
    }
}
