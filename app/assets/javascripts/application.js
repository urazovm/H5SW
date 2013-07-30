// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require twitter/bootstrap
//= require jquery-ui
//= require autocomplete-rails
//= require_tree .


function GetContact(s){
    $.ajax({
        url :'/contacts/'+jQuery(s).val()+'/ajax_show',
        dataType: 'script',
        success :function(data){
        }
    })
}

function getJobsite(s){
    $.ajax({
        type: 'GET',
        url: '/jobsites/'+ jQuery(s).val() + '/ajax_show',
        dataType: 'script',
        success: function(data){
        //            $("#jobsite").html(data);
            
        }
    });
}

function getEditJobsite(s, edit){
    $.ajax({
        type: 'GET',
        url: '/jobsites/'+ jQuery(s).val() + '/ajax_show' + "/?edit=" + edit,
        dataType: 'script',
        success: function(data){
        //            $("#jobsite").html(data);

        }
    });
}



function getJobsiteId(s){
    $.ajax({
        url: '/jobsites/'+ jQuery(s).val() + '/get_id',
        dataType: 'script',
        success: function(data){            
         window.location.reload(true);            
        }
    });   
}

$(document).ready(function(){
    $("#close").click(function(){
        $("#comment").fadeOut();
    });
});

function item_edit_form(item_id){
    $.ajax({
        url:"/items/"+item_id+"/edit",
        success:function(data){
            $("#popup_box1").show();
            $("#overlay1").show();
            $("#popup_body1").html(data);
        }
    });
}

function inventory_edit_form(inventory_id){
    $.ajax({
        url:"/inventories/"+inventory_id+"/edit",
        success:function(data){
            $("#popup_box1").show();
            $("#overlay1").show();
            $("#popup_body1").html(data);
        }
    });
}


 


function hide_popup1(){

    if(jQuery('#popup_box1')){
        jQuery('#popup_body1').html("");
        jQuery('#popup_box1').hide();
    }
    if(jQuery('#overlay1')){
        jQuery('#overlay1').hide();
    }
}

function phone_validate(which,next) {
    var val = which.value;
    val = val.replace(/[^0-9]/g,"");  // strip non-digits
    which.value = val;
    next = "customer_phone" + next;
    if (val.length == 3) {  // field completed
        document.getElementById(next).focus()
    }
}


function mobile_validate(which,next) {
    var val = which.value;
    val = val.replace(/[^0-9]/g,"");  // strip non-digits
    which.value = val;
    next = "contact_mobile" + next;
    if (val.length == 3) {  // field completed
        document.getElementById(next).focus()
    }
}


function business_validate(which,next) {
    var val = which.value;
    val = val.replace(/[^0-9]/g,"");  // strip non-digits
    which.value = val;
    next = "contact_business" + next;
    if (val.length == 3) {  // field completed
        document.getElementById(next).focus()
    }
}

$(document).ajaxStart(function(){
    $('#ajax_loader_big_div').show();
});
$(document).ajaxStop(function(){
    $('#ajax_loader_big_div').hide();
});


$(document).ready(function() {
    /* Activating Best In Place */
    $('.datepicker').datepicker()
    .on('changeDate', function(e){
        var y = e.date.getFullYear(),
        _m = e.date.getMonth() + 1,
        m = (_m > 9 ? _m : '0'+_m),
        _d = e.date.getDate(),
        d = (_d > 9 ? _d : '0'+_d);
        $(this).prev('input.data').val(y + '-' + m + '-' + d);
    });

    $("#auto_complete_text").keyup(function(){
           var n = $(this).val().split(',').length
           var data = $(this).val().split(',')[n-1];
        $.ajax({
            url:'/items/autocomplete_items',
            data:{
                name:data,
                not_list:$(this).val()
            },
            type:'GET',
            success:function(data){}
        });
    });
});

function inplace_edit_quantity(id){
    $.ajax({
        url:'/inventories/'+id+'/edit?type=qty',
        type:'GET'
    });
}

function cancel_update(id,qty){
    $("#quantity_"+id).html('<div onclick="inplace_edit_quantity('+id+')"><span style ="color :blue; background-color:#EEEEEE; padding: 1px 5px; ">'+qty+'</span></div>')
}


function inplace_edit_description(id){
    $.ajax({
        url:'/inventories/'+id+'/edit?type="description"',
        type:'GET'
    });
}



function cancel(id,description){
    $("#description_"+id).html('<div onclick="inplace_edit_description('+id+')"><span style ="color :blue; background-color:#EEEEEE; padding: 1px 5px; ">'+description+'</span></div>')
}


function getShowJobsite(s){
    $.ajax({
        type: 'GET',
        url: '/jobsites/'+ jQuery(s).val() + '/show_jobsite',
        dataType: 'script',
        success: function(data){
        //            
        }
    });
}

function getJobsitesId(s){
    $.ajax({
        url: '/jobsites/'+ jQuery(s).val() + '/get_jobsite',
        dataType: 'script',
        success: function(data){
//          window.location.reload(true);
        }
    });
}