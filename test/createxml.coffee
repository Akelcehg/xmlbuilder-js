vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Creating XML')
    .addBatch
        'Long form':
            topic: () ->
                xmlbuilder.create('root')
                    .ele('xmlbuilder')
                        .att('for', 'node-js')
                        .com('CoffeeScript is awesome.')
                        .nod('repo')
                        .att('type', 'git')
                        .txt('git://github.com/oozcitak/xmlbuilder-js.git')
                        .up()
                    .up()
                    .ele('test')
                        .att('escaped', 'chars <>\'"&')
                        .txt('complete 100%')
                    .up()
                    .ele('cdata')
                        .cdata('<test att="val">this is a test</test>\nSecond line')
                    .up()
                    .ele('raw')
                        .raw('&<>&')
                        .up()
                    .ele('atttest', { 'att': 'val' }, 'text')
                        .up()
                    .ele('atttest', 'text')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                      '<root>' +
                          '<xmlbuilder for="node-js">' +
                              '<!-- CoffeeScript is awesome. -->' +
                              '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
                          '</xmlbuilder>' +
                          '<test escaped="chars &lt;&gt;&apos;&quot;&amp;">complete 100%</test>' +
                          '<cdata><![CDATA[<test att="val">this is a test</test>\nSecond line]]></cdata>' +
                          '<raw>&<>&</raw>' +
                          '<atttest att="val">text</atttest>' +
                          '<atttest>text</atttest>' +
                      '</root>'
                assert.strictEqual topic.end(), xml

        'Long form with attributes':
            topic: () ->
                xmlbuilder.create('root')
                    .ele('xmlbuilder', {'for': 'node-js' })
                        .com('CoffeeScript is awesome.')
                        .nod('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git')
                        .up()
                    .up()
                    .ele('test', {'escaped': 'chars <>\'"&'}, 'complete 100%')
                    .up()
                    .ele('cdata')
                        .cdata('<test att="val">this is a test</test>\nSecond line')
                    .up()
                    .ele('raw')
                        .raw('&<>&')
                        .up()
                    .ele('atttest', { 'att': 'val' }, 'text')
                        .up()
                    .ele('atttest', 'text')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                      '<root>' +
                          '<xmlbuilder for="node-js">' +
                              '<!-- CoffeeScript is awesome. -->' +
                              '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
                          '</xmlbuilder>' +
                          '<test escaped="chars &lt;&gt;&apos;&quot;&amp;">complete 100%</test>' +
                          '<cdata><![CDATA[<test att="val">this is a test</test>\nSecond line]]></cdata>' +
                          '<raw>&<>&</raw>' +
                          '<atttest att="val">text</atttest>' +
                          '<atttest>text</atttest>' +
                      '</root>'
                assert.strictEqual topic.end(), xml

        'Short form with attributes':
            topic: () ->
                xmlbuilder.create('root')
                    .e('xmlbuilder', {'for': 'node-js' })
                        .c('CoffeeScript is awesome.')
                        .n('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git')
                        .u()
                    .u()
                    .e('test', {'escaped': 'chars <>\'"&'}, 'complete 100%')
                    .u()
                    .e('cdata')
                        .d('<test att="val">this is a test</test>\nSecond line')
                    .u()
                    .e('raw')
                        .r('&<>&')
                        .u()
                    .e('atttest', { 'att': 'val' }, 'text')
                        .u()
                    .e('atttest', 'text')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                      '<root>' +
                          '<xmlbuilder for="node-js">' +
                              '<!-- CoffeeScript is awesome. -->' +
                              '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
                          '</xmlbuilder>' +
                          '<test escaped="chars &lt;&gt;&apos;&quot;&amp;">complete 100%</test>' +
                          '<cdata><![CDATA[<test att="val">this is a test</test>\nSecond line]]></cdata>' +
                          '<raw>&<>&</raw>' +
                          '<atttest att="val">text</atttest>' +
                          '<atttest>text</atttest>' +
                      '</root>'
                assert.strictEqual topic.end(), xml

        'create() without with arguments':
            topic: () ->
                xmlbuilder.create('test14').ele('node').txt('test')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?><test14><node>test</node></test14>'
                assert.strictEqual topic.end(), xml

        'create() with with arguments':
            topic: () ->
                xmlbuilder.create('test14', { 'version': '1.1' }).ele('node').txt('test')

            'resulting XML': (topic) ->
                xml = '<?xml version="1.1"?><test14><node>test</node></test14>'
                assert.strictEqual topic.end(), xml

        'create() with with merged arguments':
            topic: () ->
                xml1 = xmlbuilder.create('test14', { version: '1.1', encoding: 'UTF-8', standalone: true, ext: 'hello.dtd' })
                    .ele('node').txt('test')
                xml2 = xmlbuilder.create('test14', { headless: true, version: '1.1', encoding: 'UTF-8', standalone: true, ext: 'hello.dtd' })
                    .ele('node').txt('test')
                [xml1, xml2]

            'resulting XML1': (topic) ->
                xml1 = '<?xml version="1.1" encoding="UTF-8" standalone="yes"?>' +
                       '<!DOCTYPE test14 hello.dtd><test14><node>test</node></test14>'
                assert.strictEqual topic[0].end(), xml1

            'resulting XML2': (topic) ->
                xml2 = '<test14><node>test</node></test14>'
                assert.strictEqual topic[1].end(), xml2


    .export(module)

