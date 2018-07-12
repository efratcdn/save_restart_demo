   dynamic loadable file

   extending the hook tcm

<'
extend MAIN packet_seq {
    post_restore_scenario() @driver.clock is also {
   
        driver.raise_objection(TEST_DONE);
        
        do packet keeping {it.addr == 100; .data == 0x11};
        do packet keeping {it.addr == 100; .data == 0x22};
        do packet keeping {it.addr == 100; .data == 0x33};
        do packet keeping {it.addr == 100; .data == 0x44};  
        
        driver.drop_objection(TEST_DONE);

    };
};
'>

