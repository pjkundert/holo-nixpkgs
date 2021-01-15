from base64 import b64encode
from hashlib import sha512
import click
import json
import requests


@click.group()
@click.option('--url', help='HPOS Holochain HTTP URL')
@click.pass_context
def cli(ctx, url):
    ctx.obj['url'] = url

def request(ctx, method, path, **kwargs):
    return requests.request(method, ctx.obj['url'] + path, **kwargs)

@cli.command(help='Get info on happs currently hosted')
@click.pass_context
def hosted_happs(ctx):
    print(request(ctx, 'GET', '/hosted_happs').json())

@cli.command(help='Pass a happ_id to be installed as a hosted happ')
@click.argument('happ_id')
@click.pass_context
def install_hosted_happ(ctx, happ_id):
    print(request(ctx, 'POST', '/install_hosted_happ', params={'happ_id': happ_id}))

if __name__ == '__main__':
    cli(obj={})
