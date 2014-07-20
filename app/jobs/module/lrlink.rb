# encoding: utf-8
require 'domainatrix'
require 'uri'

module Lrlink
  def get_domain_info_by_host(host)
    url = Domainatrix.parse(host)
    if url.domain && url.public_suffix
      return url
    end
    nil
  end

  def host_port_of_url(url)
    begin
      url = 'http://'+url+'/' if !url.include?('http://') and !url.include?('https://')
      url = URI.encode(url) unless url.include? '%' #如果包含百分号%，说明已经编码过了
      uri = URI(url)
      [uri.host, uri.port]
    rescue => e
      nil
    end
  end

  def host_of_url(url)
    begin
      url = 'http://'+url+'/' if !url.include?('http://') and !url.include?('https://')
      url = URI.encode(url) unless url.include? '%' #如果包含百分号%，说明已经编码过了
      uri = URI(url)
      uri.host
    rescue => e
      nil
    end
  end

  def hostinfo_of_url(url)
    begin
      url = 'http://'+url+'/' if !url.include?('http://') and !url.include?('https://')
      url = URI.encode(url) unless url.include? '%' #如果包含百分号%，说明已经编码过了
      uri = URI(url)
      rr = uri.host
      rr = rr+':'+uri.port.to_s if uri.port!=80 && uri.port!=443
      rr
    rescue => e
      nil
    end
  end

  def get_linkes(html)
    arr = []
    if html
      html.scan(/(http[s]?:\/\/.*?)[ \/\'\"\>]/).each{|x|
        if x[0].size>8 && x[0].include?('.')
          hostinfo = hostinfo_of_url(x[0].downcase)
          arr << hostinfo if hostinfo
        end
      }
    end
    arr.uniq
  end

  def get_ip_of_host(host)
    require 'socket'
    ip = Socket.getaddrinfo(host, nil)
    return nil if !ip || !ip[0] || !ip[0][2]
    ip[0][2]
  rescue => e
    nil
  end

  def is_bullshit_title?(title,subdomain)
    $titles=%q{娱乐城
博彩
赌博
投注
时时彩
外围现金
百家乐
_百度百科
_百度认证
皇冠比分
台湾佬娱乐网
草裙社区
终结毁灭
仿盛大传奇
传奇加速器
私服
传奇下载
传奇SF
传奇1.85客户端
迷失传奇
嘟嘟传奇
我本沉默版本攻略
赌场
银行卡【电话
成人激情
丁香五月
色五月
一干燥设备有限公司
今日新开网页版传奇
英雄合击-
极品星王合击传奇
变态
変态
超变65535
连击
合击
[新开
私服
1.76蓝魔
我本沉默
SF_
sf_
热血战神
新开神途
神途传说2_
盛世三国开服表
_神途帝国
[超凡官网]
下载_[2014
_1.7
_1.8
网通传奇
新开1
_传奇
_超变
最新2.
外挂
热血传奇
霸域传奇
最新2
传奇1.7
倚天荣耀
英雄传奇
仿盛大
传奇服务
热血传奇
合成传世
天神轻变
传奇归来
战神传奇
传奇版本下载
中变传奇九转
旷世皓月
1.90版山寨大王传奇
1.85必杀
1.76精品
1.76赤月
绿茵传奇
热血传奇
便民导航
领养小孩
[电话
赌球
真人娱乐
棋牌
百乐坊娱乐
足彩
发票
开票
反恐精英2_官网免费下载
反恐精英online官网_官网免费下载
【平台直属QQ
【信誉匿名银行卡
按洗浴摩中心
www.296296.com
皇冠现金网
车震门
不雅视频
合成图
交易门
美女艳照
写真集_
做爱视频
同志聊天
日本大胆人体艺术
强奸
色站导航
五月情色天
性虐待
我要性|交网
【2014百度官网认证】
克隆真票}
    return false if !subdomain || subdomain.size<1 || subdomain=='www' #根域名和www先不处理
    $titles.each_line{|t|
      return true if t && t.size>1 && title.include?(t.strip)
    }
    false
  end

  def is_bullshit_host?(host)
    $hosts=%q{.100ye.com
.1254.it
.12market.com
.1688.com
.243mm.com
.269g.net
.47365.com
.51cto.com
.51sole.com
.54114.com
.58.com.cn
.5d6d.com
.8671.net
.9ye.com
.alibaba.com
.b2b168.com
.baike.com
.bb.babynic.cn
.beon.ru
.best73.com
.bloblo.pl
.blog.163.com
.blog.ankang06.org
.blog.bokee.net
.blog.fc2.com
.blog.hexun.com
.blog.ir
.blog.is
.blog.jp
.blog.pl
.blog.sohu.com
.blogbus.com
.blogchina.com
.blogcu.com
.blogfa.com
.blogg.se
.blogsky.com
.blogspot.com
.blogspot.ro
.bloog.pl
.blox.pl
.biz72.com
.boke.babynic.cn
.bxlwt.com
.c-c.com
.cailiao.com
.canalblog.com
.class.ankang06.org
.cn21edu.com
.cs090.com
.dianhi.com
.diarynote.jp
.decoo.jp
.deviantart.com
.digart.pl
.edublogs.org
.fang.com
.fc2blog.us
.fcwlm.cn
.fjsq.org
.flog.pl
.fmix.pl
.gerelateerd.nl
.goedbegin.nl
.gyxu.com
.hn73.com
.huamu.cn
.i.sohu.com
.lasporn.com
.linkbucks.com
.list-manage.com
.list-manage1.com
.list-manage2.com
.livejournal.com
.porntubeindex.com
.idnes.cz
.ieskok.lt
.interia.pl
.jouwpagina.nl
.jt160.com
.jugem.jp
.lapozz.hu
.ltalk.ru
.maakjestart.nl
.majorcommand.com
.makepolo.com
.mihanblog.com
.mmfj.com
.net114.com
.ninemarket.com
.niniweblog.com
.olx.bg
.onet.pl
.only3xsex.com
.over-blog.com
.parsiblog.com
.persianblog.ir
.pinger.pl
.psy.elk.pl
.qaix.com
.qjy168.com
.qu114.cn
.radio.de
.rock.cz
.rpod.ru
.saige.com
.salon24.pl
.seesaa.net
.shangpusou.com
.sharera.com
.skyrock.com
.so-net.ne.jp
.soufun.com
.soup.io
.startpagina.nl
.sublimeblog.net
.t.sohu.com
.taobao.com
.tianya.cn
.tianyablog.com
.tmall.com
.toplinkjes.com
.tumblr.com
.unblog.fr
.uol.ua
.userapi.com
.vip.yl1001.com
.vk.me
.wanknews.com
.wordpress.com
.ynshangji.com
.yjycw.com
.ymjx168.com
.zhuts.com}
    $hosts.each_line{|h|
      return true if h && h.size>5 && host.end_with?(h.strip)
    }
    false
  end

  def is_bullshit_ip?(ip)
    $ips = %q{0.0.0.0
101.226.10.
103.24.92.
103.240.183.
103.242.135.
103.242.3.
103.243.26.
103.244.148.
103.248.36.
103.27.124.
103.27.177.
106.186.28.
107.148.40.
107.149.121.
107.149.149.
107.149.150.
107.149.155.
107.149.208.
107.149.55.
107.149.82.
107.160.127.
107.160.128.
107.160.129.
107.160.136.
107.160.151.
107.160.152.
107.160.153.
107.160.154.
107.160.157
107.160.169.
107.160.183.
107.160.24.
107.160.38.
107.160.83.
107.160.84.
107.163.130.
107.163.132.
107.163.136.
107.163.27.
107.163.4.
107.167.15.
107.167.74.
107.178.159.
107.178.181.
107.178.182.
107.178.92.
107.181.242.
107.181.245.
107.182.140.
107.183.107.
107.183.109.
107.183.152.
107.183.204.
107.183.22.
107.183.41.
107.183.9.
107.189.129.
107.189.134.
107.189.144.
107.189.146.
107.189.149.
107.189.154.
107.189.157.
107.6.46.
108.171.249.
108.177.153.
108.186.70.
108.187.84.
108.62.165.
108.62.237.
115.47.54.136
115.126.112.
115.126.23.
115.126.27.
116.212.115.
116.212.126.
116.254.222.
116.255.214.
117.18.5.
118.99.21.
118.99.57.
122.10.114.
122.10.38.
122.10.82.
122.10.91.
122.112.2.
122.136.32.
122.9.125.
122.9.129.
122.9.130.
122.9.132.
122.9.134.
122.9.138.
122.9.141.
122.9.192.
122.9.229.
122.9.235.
123.125.81.
124.248.222.
124.248.229.
124.248.240.
124.248.244.
124.248.251.
137.175.109
137.175.124.
137.175.2.
137.175.57.
137.175.61.
137.175.64.
137.175.88.
142.0.142.
142.54.190.
144.76.203.
146.148.146.
146.148.147.
146.148.148.
146.148.149.
146.148.150.
146.148.151.
146.148.152.
146.148.153.
146.71.35.
146.71.56.
146.71.57.
146.71.58.
146.71.59.
148.163.16.
148.163.55.
159.63.88.
162.209.202.
162.220.24.
162.209.240.
162.209.241.
162.209.243.
162.211.24.
162.218.118.
162.255.181.
170.75.149.
172.240.120.
172.240.60.
172.240.95.
172.240.96.
172.241.139.
172.241.80.
172.246.53.
172.246.117.
172.246.119.
172.246.14.
172.246.228.
172.247.230.
172.247.231.
172.255.207.
173.208.182.
173.208.68.
173.208.68.
174.129.12.
174.139.100.
174.139.171.
174.139.224.
174.139.43.
174.139.6.
174.139.96.
174.128.230.
182.254.143.
192.126.115.
192.151.145.
192.157.203.
192.157.223.
192.157.234.
192.157.247.
192.169.105.
192.169.109.
192.169.111.
192.186.12.
192.250.205.
192.74.240.
192.80.155.
192.80.161.
192.80.184.
192.99.215.
194.79.52.
198.13.100.
198.13.112.
198.148.92.
198.2.239.
198.204.228.
198.204.234.
198.204.238.
198.27.91.
198.55.114.
198.56.150.
198.56.177.
198.56.210.
198.56.219.
198.56.241.
198.56.253.
198.98.113.
198.98.97.
199.182.233.
199.182.234.
199.233.237.
199.48.69.
204.12.248.
204.152.199.
205.209.169.
208.66.76.
211.149.187.
211.149.204.
211.44.3.
216.158.92.
219.127.222.
219.139.130.
222.215.230.
23.104.160.
23.104.160.
23.104.19.
23.104.20.
23.104.3.
23.104.36.
23.105.26.
23.105.28.
23.105.29.
23.105.35.
23.105.52.
23.105.79.
23.105.83.
23.106.236.
23.107.74.
23.110.102.
23.110.125
23.110.147.
23.110.244.
23.110.25.
23.110.46.
23.110.58.
23.224.45.
23.226.178.
23.226.64.
23.226.74.
23.226.76.
23.228.219.
23.228.225.
23.238.149.
23.238.206.
23.234.48.
23.244.143.
23.244.147.
23.244.148
23.244.20.
23.244.23.
23.244.208.
23.244.223.
23.245.100.
23.245.120.
23.245.134.
23.245.152.
23.245.199.
23.245.206.
23.245.213.
23.245.235
23.245.24.
23.245.54.
23.245.65.
23.245.66.
23.248.213.
23.27.192.
23.80.165.
23.80.169.
23.80.182.
23.80.189.
23.80.193.
23.80.209.
23.80.226.
23.80.248.
23.80.48.
23.80.50.
23.80.51.
23.80.77.
23.80.90.
23.81.36.
23.82.231.
23.82.61.
23.83.57.
23.88.170.
23.88.183.
23.88.95.
23.89.98.
23.89.147.
23.89.150.
23.89.157.
23.89.160.
23.89.167.
23.89.208.
23.89.61.
23.89.82.
23.90.165.
23.90.189.
42.121.52.
42.96.195.43
43.252.229.
46.28.209.
49.212.132.
50.118.98.
59.39.7.
59.45.75.
60.28.245.173
63.141.225.
63.141.226.
63.141.232.
64.74.223.
65.19.141.
65.19.157.
67.229.62.
68.64.161.
69.12.87.
69.12.87.
69.165.69.
69.90.191.
71.18.124.
71.18.137.
71.18.193.
72.52.4.
74.82.63.
74.91.30.
76.162.215
76.163.191
76.163.92.
76.74.218.
8.5.1.
91.195.240.
98.126.196.
98.126.89.
98.131.26.}
    return true if !ip
    $ips.each_line{|bip|
      return true if bip && bip.size>4 && ip.start_with?(bip.strip)
    }
    false
  end

end