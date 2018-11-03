"use strict";
exports.__esModule = true;
exports.activate = function (oni) {
    console.log("config activated");
    // Input
    //
    // Add input bindings here:
    //
    oni.input.bind("<c-enter>", function () { return console.log("Control+Enter was pressed"); });
    //
    // Or remove the default bindings here by uncommenting the below line:
    //
    // oni.input.unbind("<c-p>")
};
exports.deactivate = function (oni) {
    console.log("config deactivated");
};
exports.configuration = {
    "oni.useExternalPopupMenu": true,
    "oni.hideMenu": "hidden",
    "oni.quickInfo.enabled": true,
    "oni.quickInfo.delay": 500,
    "ui.colorscheme": "solarized-light",
    "ui.fontSize": "20px",
    "autoClosingPairs.enabled": false,
    "tabs.mode": "buffers",
    "language.cpp.languageServer.command": "clangd-6.0",
    "language.cpp.completionTriggerCharacters": [".", ">"],
    "language.c.languageServer.command": "clangd-6.0",
    "language.c.completionTriggerCharacters": [".", ">"],
    "language.rust.languageServer.command": "rustup",
    "language.rust.languageServer.arguments": ["run", "stable", "rls"],
    "language.rust.languageServer.rootFiles": ["Cargo.toml"],
    "editor.errors.slideOnFocus": true,
    //"oni.useDefaultConfig"   : true,
    //"oni.bookmarks"          : ["~/Documents"],
    //"oni.loadInitVim"        : false,
    "editor.fontFamily": "DejaVu Sans Mono",
    "editor.fontSize": "20px",
    "editor.clipboard.enabled": true,
    // UI customizations
    "ui.animations.enabled": true,
    "learning.enabled": false,
    "ui.fontSmoothing": "auto"
};
