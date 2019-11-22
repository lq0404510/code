package com.qfedu.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

import java.util.Random;

/**
 * @program: redisverifycode
 * @author: FF
 * @date: 2019-11-20 22:13
 */
@RestController
public class UserController {
    @RequestMapping("/sendCode")
    public String sendCode(String phone) {

        if (phone == null) {
            return "error";
        }

        String verifyCode = genCode(4);
        JedisPool jedisPool = new JedisPool("192.168.197.128", 6379);
        Jedis jedis = jedisPool.getResource();

        /* 一天之内只能发送验证码3次*/
        String num = jedis.get("num:" + phone);

        if (num == null) {
            jedis.setex("num:" + phone, 3600 * 24, "3");
        } else if (!num.equals("1")){
            jedis.decr("num:" + phone);
        } else {
            return "num";
        }

        String phonekey = "phone_num:" + phone;
        jedis.setex(phonekey, 20, verifyCode);

        //System.out.println("jedis上的验证码:" + jedis.get(phonekey));

        jedis.close();
        System.out.println("验证码:" + verifyCode);
        return "success";
    }

    private String genCode(int code_length) {
        String code = "";
        for (int i = 0; i < code_length; i++) {
            int num = new Random().nextInt(10);
            code += num;
        }
        return code;
    }

    @RequestMapping("/verifiCode")
    public String verifiCode(String phone, String verify_code) {
        if (verify_code == null) {
            return "error";
        }

        Jedis jedis = new Jedis("192.168.197.128", 6379);

        String phonekey = jedis.get("phone_num:" + phone);
        System.out.println(phonekey);

        if (verify_code.equals(phonekey)) {
            return "success";
        }

        jedis.close();
        return "error";
    }
}
