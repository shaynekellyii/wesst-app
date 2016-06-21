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
    TextView tvGender;
    TextView tvInfo;
    TextView tvPhone;
    TextView tvDate;

    Button btEditProfile;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_profile, container, false);

        tvFullName = (TextView) rootView.findViewById(R.id.tvFullName);
        tvSchool = (TextView) rootView.findViewById(R.id.tvSchool);
        tvTitle = (TextView) rootView.findViewById(R.id.tvTitle);
        tvEmail = (TextView) rootView.findViewById(R.id.tvEmail);
        tvGender = (TextView) rootView.findViewById(R.id.tvGender);
        tvInfo = (TextView) rootView.findViewById(R.id.tvInfo);
        tvPhone = (TextView) rootView.findViewById(R.id.tvPhone);
        tvDate = (TextView) rootView.findViewById(R.id.tvDate);
        btEditProfile = (Button)rootView.findViewById(R.id.btEditProfile);

        btEditProfile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(getActivity(), EditProfileActivity.class);
                startActivity(intent);
            }
        });

        return rootView;
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        populateProfile();
    }

    @Override
    public void onResume() {
        super.onResume();
        populateProfile();
    }

    private void populateProfile() {
        ParseUser user = ParseUser.getCurrentUser();
        String notSpecified = getActivity().getString(R.string.not_specified);
        if (user != null) {
            if (user.get("fullname") != null) {
                tvFullName.setText(user.get("fullname").toString());
            }
            else {
                tvFullName.setVisibility(View.GONE);
                getView().findViewById(R.id.tvFullNameLabel).setVisibility(View.GONE);
            }
            if (user.get("school") != null) {
                tvSchool.setText(user.get("school").toString());
            }
            else {
                tvSchool.setVisibility(View.GONE);
                getView().findViewById(R.id.tvSchoolLabel).setVisibility(View.GONE);
            }
            if (user.get("title") != null) {
                tvTitle.setText(user.get("title").toString());
            }
            else {
                tvTitle.setVisibility(View.GONE);
                getView().findViewById(R.id.tvTitleLabel).setVisibility(View.GONE);
            }
            if (user.getEmail() != null) {
                tvEmail.setText(user.getEmail());
            }
            else {
                tvEmail.setVisibility(View.GONE);
                getView().findViewById(R.id.tvEmailLabel).setVisibility(View.GONE);
            }

            if (user.get("gender") != null) {
                tvGender.setText(user.get("gender").toString());
            }
            else {
                tvGender.setVisibility(View.GONE);
                getView().findViewById(R.id.tvGenderLabel).setVisibility(View.GONE);
            }
            if (user.get("info") != null) {
                tvInfo.setText(user.get("info").toString());
            }
            else {
                tvInfo.setVisibility(View.GONE);
                getView().findViewById(R.id.tvInfoLabel).setVisibility(View.GONE);
            }
            if (user.get("phone") != null) {
                tvPhone.setText(user.get("phone").toString());
            }
            else {
                tvPhone.setVisibility(View.GONE);
                getView().findViewById(R.id.tvPhoneLabel).setVisibility(View.GONE);
            }
            if (user.get("birthday") != null) {
                tvDate.setText(user.get("birthday").toString());
            }
            else {
                tvDate.setVisibility(View.GONE);
                getView().findViewById(R.id.tvDateLabel).setVisibility(View.GONE);
            }
        }
    }
}