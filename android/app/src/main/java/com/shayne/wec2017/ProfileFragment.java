package com.shayne.wec2017;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.parse.ParseUser;

/**
 * Created by Shayne on 2016-06-21.
 */

public class ProfileFragment extends Fragment {

    TextView tvFullName;
    TextView tvSchool;
    TextView tvTitle;
    TextView tvEmail;
    Button btEditProfile;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_profile, container, false);

        tvFullName = (TextView) rootView.findViewById(R.id.tvFullName);
        tvSchool = (TextView) rootView.findViewById(R.id.tvSchool);
        tvTitle = (TextView) rootView.findViewById(R.id.tvTitle);
        tvEmail = (TextView) rootView.findViewById(R.id.tvEmail);
        btEditProfile = (Button)rootView.findViewById(R.id.btEditProfile);

        populateProfile();

        btEditProfile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(getActivity(), EditProfileActivity.class);
                startActivity(intent);
            }
        });

        return rootView;
    }

    private void populateProfile() {
        ParseUser user = ParseUser.getCurrentUser();
        String notSpecified = getActivity().getString(R.string.not_specified);
        if (user != null) {
            if (user.get("fullname") != null) {
                tvFullName.setText(user.get("fullname").toString());
            } else {
                tvFullName.setText(notSpecified);
            }
            if (user.get("school") != null) {
                tvSchool.setText(user.get("school").toString());
            } else {
                tvSchool.setText(notSpecified);
            }
            if (user.get("title") != null) {
                tvTitle.setText(user.get("title").toString());
            } else {
                tvSchool.setText(notSpecified);
            }
            if (user.getEmail() != null) {
                tvEmail.setText(user.getEmail());
            } else {
                tvSchool.setText(notSpecified);
            }
        }
    }
}