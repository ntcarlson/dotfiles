#!/usr/bin/env bash

# Convenience wrapper for launching different rofi modes w/ associated themes


case "$1" in
    run)
        rofi -modi run -show run -theme list \
             -display-run "Run command";;
    applications)
        rofi -modi drun -show drun -theme grid \
             -display-drun "Launch application";;
    games)
        rofi -theme grid -modi drun -show drun -theme grid \
             -display-drun "Launch game" \
             -drun-categories Game;;
    window)
        rofi -modi window -show window -theme list \
             -display-window "Search open windows";;
    options)
        echo TODO;;
esac
