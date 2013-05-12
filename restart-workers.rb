#!/usr/bin/env ruby

# Copyright (c) 2013, Calculated Content (TM)
# All rights reserved.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL MADE BY MADE LTD BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'rubygems'
require 'fog'
require 'socket'
require 'logger'

aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
aws_region = ENV['EC2_REGION']

log = Logger.new("restart-workers.log", shift_age = 7, shift_size = 1048576)

begin  

  c = Fog::Compute.new(
  :provider => 'AWS',
  :aws_secret_access_key => aws_secret_access_key,
  :aws_access_key_id => aws_access_key_id,
  :region => aws_region )

  raise 'can not connect' if c.nil?
 
  stopped_workers = c.servers.select { |s| s.state=='stopped' }

  log.info  "found #{stopped_workers.size} stopped_workers"
  stopped_workers.each do |w|  
    log.info "starting worker #{w.to_s}"
    w.start 
  end

rescue  Exception => e  
  log.warn e.message
  log.warn e.backtrace.inspect   
end





