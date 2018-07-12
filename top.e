
top.e 
  
  very small "testbench".
  
  if SAVE_THE_RUN is defined - saving the run after finished  the reset
  
  
<'

struct packet like any_sequence_item {
    %addr  : byte;
    %data  : int;
    %tail  : int;
    
    del    : int;
    
    keep tail in [1..100];
    keep del in [5..77];
};

sequence packet_seq using item=packet, created_driver = packet_seqer;

extend packet_seqer {
    keep hdl_path() == "dut_demo";
    sig_clock : in simple_port of bit is instance;
    keep bind (sig_clock, external);
    keep sig_clock.hdl_path() == "dut_clock";
    event clock is only rise(sig_clock$) @sim;
   
    
    // dummy bfm, we want to demonstrate save-restore, nothing else
    bfm() @clock is {
        var packet : packet;
        while TRUE {
            packet = get_next_item();
            message(LOW, "sending packet to ", packet.addr, " tail ", packet.tail);
            wait [packet.del] * cycle;
            emit item_done;
        };
    };
    
    run() is also {
        start bfm();
    };
};


extend MAIN packet_seq {
    !packet : packet;

    
    body() @driver.clock is only {
        driver.raise_objection(TEST_DONE);
        // "reset"
        for i from 0 to 20 {
            do packet keeping {it.addr == i};
        }; 
        emit sys.env.reset_done;

        wait [17] * cycle;
        for i from 0 to 70 {
            do packet;
        };
        driver.drop_objection(TEST_DONE);
    };
    
    
    // preparing hook, to be extended in dynamic loaded files
    post_restore_scenario() @driver.clock is {};
    
};


extend sys {
    env : env is instance;
};

unit env {
    seqer   : packet_seqer is instance;
    
    event clock is @sys.any;
    event reset_done;
};


extend env {    
    
    on reset_done {          
        #ifdef SAVE_THE_RUN {
            start sys.simulator_save("after_reset", TRUE, FALSE); 
        }; // #ifdef SAVE_THE_RUN
    };
  };




extend env {
    run() is also {
        set_config(run, tick_max, 1000000);
        specman("echo event env.*r*");
    };
};



'>
