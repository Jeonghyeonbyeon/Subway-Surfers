using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : MonoBehaviour
{
    public static AudioManager instance;

    [Header("-----AudioSource-----")]
    [SerializeField] private AudioSource bgmSource;
    [SerializeField] private AudioSource sfxSource;

    [Header("-----AudioClip-----")]
    public AudioClip inGame;
    public AudioClip coin;
    public AudioClip itemBox;

    private void Awake()
    {
        instance = this;
    }

    private void Start() => PlayBGMLoop();

    public void PlayBGMLoop()
    {
        bgmSource.clip = inGame;
        bgmSource.loop = true;
        bgmSource.Play();
    }

    public void PlaySFX(AudioClip clip)
    {
        sfxSource.PlayOneShot(clip);
    }
}
