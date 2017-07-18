/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Metal shaders used for this sample
 */

#include <metal_stdlib>
using namespace metal;

struct ModelConstants {
    float4x4 modelViewMatrix;
    float4 materialColor;
    float3x3 normalMatrix;
    float specularIntensity;
    float shininess;
};

struct SceneConstants {
    float4x4 projectionMatrix;
};

struct VertexIn {
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float2 textureCoordinates [[ attribute(2) ]];
    float3 normal [[ attribute(3) ]];
};

struct VertexOut {
    float4 position [[ position ]];
    float4 color;
    float2 textureCoordinates;
    float4 materialColor;
    float3 normal;
    float specularIntensity;
    float shininess;
    float3 eyePosition;
};

struct Light {
    float3 color;
    float ambientIntensity;
    float diffuseIntensity;
    float3 direction;
};

vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                               constant ModelConstants &modelConstants [[ buffer(1) ]],
                               constant SceneConstants &SceneConstants [[ buffer(2) ]]) {
    VertexOut vertexOut;
    
    float4x4 matrix = SceneConstants.projectionMatrix * modelConstants.modelViewMatrix;
    vertexOut.position = matrix * vertexIn.position;
    
    vertexOut.color = vertexIn.color;
    vertexOut.textureCoordinates = vertexIn.textureCoordinates;
    vertexOut.materialColor = modelConstants.materialColor;
    vertexOut.normal = modelConstants.normalMatrix * vertexIn.normal;
    vertexOut.specularIntensity = modelConstants.specularIntensity;
    vertexOut.shininess = modelConstants.shininess;
    vertexOut.eyePosition = (modelConstants.modelViewMatrix * vertexIn.position).xyz;
    
    return vertexOut;
}

vertex VertexOut vertex_instance_shader(const VertexIn vertexIn [[ stage_in ]],
                                        constant ModelConstants *instances [[ buffer(1) ]],
                                        constant SceneConstants &SceneConstants [[ buffer(2) ]],
                                        uint instanceId [[ instance_id ]]) {
    ModelConstants modelConstants = instances[instanceId];
    
    VertexOut vertexOut;
    
    float4x4 matrix = SceneConstants.projectionMatrix * modelConstants.modelViewMatrix;
    vertexOut.position = matrix * vertexIn.position;
    
    vertexOut.color = vertexIn.color;
    vertexOut.textureCoordinates = vertexIn.textureCoordinates;
    vertexOut.materialColor = modelConstants.materialColor;
    vertexOut.normal = modelConstants.normalMatrix * vertexIn.normal;
    vertexOut.specularIntensity = modelConstants.specularIntensity;
    vertexOut.shininess = modelConstants.shininess;
    vertexOut.eyePosition = (modelConstants.modelViewMatrix * vertexIn.position).xyz;
    
    return vertexOut;
}

fragment half4 fragment_shader(VertexOut vertexIn [[ stage_in ]]) {
    return half4(vertexIn.color);
}

fragment half4 textured_fragment(VertexOut vertexIn [[ stage_in ]], sampler sampler2d [[ sampler(0) ]], texture2d<float> texture [[ texture(0) ]]) {
    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
    color = color * vertexIn.materialColor;
    if (color.a == 0.0)
        discard_fragment();
    return half4(color.r, color.g, color.b, 1);
}

fragment half4 fragment_color(VertexOut vertexIn [[ stage_in ]]) {
    return half4(vertexIn.materialColor);
}

fragment half4 lit_textured_fragment(VertexOut vertexIn [[ stage_in ]],
                                     sampler sampler2d [[ sampler(0) ]],
                                     texture2d<float> texture [[ texture(0) ]],
                                     constant Light &light [[ buffer(3) ]]) {
    float4 color = texture.sample(sampler2d, vertexIn.textureCoordinates);
    color = color * vertexIn.materialColor;
    
    // Ambient
    float3 ambientColor = light.color * light.ambientIntensity;
    
    // Diffuse
    float3 normal = normalize(vertexIn.normal);
    float diffuseFactor = saturate(-dot(normal, light.direction));
    float3 diffuseColor = light.color * light.diffuseIntensity * diffuseFactor;
    
    // Specular
    float3 eye = normalize(vertexIn.eyePosition);
    float3 reflection = reflect(light.direction, normal);
    float specularFactor = pow(saturate(-dot(reflection, eye)), vertexIn.shininess);
    float3 specularColor = light.color * vertexIn.specularIntensity * specularFactor;
    
    color = color * float4(ambientColor + diffuseColor + specularColor, 1);
    
    if (color.a == 0.0)
        discard_fragment();
    return half4(color.r, color.g, color.b, 1);
}

