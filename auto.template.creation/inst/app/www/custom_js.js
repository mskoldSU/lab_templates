$( document ).ready(function() {
    show_order_spec = false;

    Shiny.addCustomMessageHandler('show_hide_order_spec', function(status) {
        show_order_spec = status;
    })
});
